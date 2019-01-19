//We are using d3.js (v3), jquery and topojson (https://github.com/topojson or https://github.com/topojson/topojson)
// TopoJSON is an extension of GeoJSON that encodes topology. Combined with fixed-precision encoding for coordinates, TopoJSON is usually much smaller than GeoJSON.

/* 

D3 works with two types of geographic JSON, GeoJSON, and a format called TopoJSON.

GeoJSON vs. TopoJSON
TopoJSON is an extension of GeoJSON that encodes topology. Rather than representing geometries discretely, geometries in TopoJSON files are stitched together from shared line segments called arcs.

*/

$(document).ready(function () {
    // Width and Height of the whole visualization
    var w = 950,
        h = 480;

    //D3 has some internal functionality that can turn GeoJSON data into screen coordinates based on the projection you set. This is not unlike other libraries such as Leaflet, but the result is much more open-ended, not constrained to shapes on a tiled Mercator map.1 So, yes, D3 supports projections.
    var projection = d3.geo.equirectangular()
    // Create GeoPath function that uses built-in D3 functionality to turn
    // lat/lon coordinates into screen coordinates
    var path = d3.geo.path()
        .projection(projection);
    //add the following to create our SVG canvas.
    var svg = d3.select('#map')
        .append('svg')
        .attr('width', w)
        .attr('height', h)
    svg.append('rect')
        .attr('width', w)
        .attr('height', h)
        .attr('fill', 'white');
    // Append empty placeholder g element to the SVG
    // g will contain geometry elements
    var g = svg.append("g");

    //add a call to d3.json to load the TopoJSON file
    //so it loads into our visualization
    d3.json('https://d3js.org/world-50m.v1.json', function (error, data) {
        if (error) {
            console.error(error);
        }
        
        g.append('path')
            .datum(topojson.feature(data, data.objects.countries))
            .attr('d', path);

        //create the zoom effect
        var zoom = d3.behavior.zoom()
            .scaleExtent([1, 50])
            .on("zoom", function () {
                g.attr("transform", "translate(" +
                    d3.event.translate.join(",") + ")scale(" + d3.event.scale + ")");
                g.selectAll("path")
                    .attr("d", path.projection(projection));
            });
        svg.call(zoom);

        // Load the data from the json file
        d3.json('json/freshwater.json', function (error, data) {
            if (error) {
                console.error(error);
            }

            var locations = data;
            
            locations.map(function (d) {
                 var l = Math.floor(Math.random() * 80) + 30;
                 d.color = `hsl(200, 100%, ${l}%)`;
            });

            // Classic D3... Select non-existent elements, bind the data, append the elements, and apply attributes
            g.selectAll('circle')
                .data(locations)
                .enter()
                .append('circle') //show the circles
                .attr('cx', function (d) {
                    if (d.geometry) {
                        return projection([d.geometry.coordinates[0], d.geometry.coordinates[1]])[0];
                    }
                })
                .attr('cy', function (d) {
                    if (d.geometry) {
                        return projection([d.geometry.coordinates[0], d.geometry.coordinates[1]])[1];
                    }
                })
                .attr('r', function (d) {
                    if (d.fields.irfr_flows_2013) {
                        return Math.pow(parseInt(d.fields.irfr_flows_2013), 1 / 2.5);
                    }
                })
                .style('fill', function (d) {
                    //Use the Color Function to set the Fill Value for each circle
                    return d.color;
                })

            //Next, we need to write two pieces of code, one that listens for when the value of the tooltip changes, and one that updates the SVG elements.
            //We are going to use some D3 code to listen for an input change on the tooltip elements

            //Add Event Listeners | mouseover
            //        .on('mouseover', function(d) {
            //          d3.select(this).style('fill', 'black'); 
            //          d3.select('#name').text(d.properties.name);
            //          d3.select('#nametype').text(d.properties.nametype);
            //          d3.select('#fall').text(d.properties.fall);
            //          d3.select('#mass').text(d.properties.mass);
            //          d3.select('#recclass').text(d.properties.recclass);
            //          d3.select('#reclat').text(d.properties.reclat);
            //          d3.select('#reclong').text(d.properties.reclong);
            //          d3.select('#year').text(d.properties.year);
            //          d3.select('#tooltip')
            //            .style('left', (d3.event.pageX + 20) + 'px')
            //            .style('top', (d3.event.pageY - 80) + 'px')
            //            .style('display', 'block')
            //            .style('opacity', 0.8)
            //        })
            //        //Add Event Listeners | mouseout
            //        .on('mouseout', function(d) { 
            //          d3.select(this).style('fill', d.color);
            //          d3.select('#tip')
            //            .style('display', 'none');
            //        });
        });
    });
});
