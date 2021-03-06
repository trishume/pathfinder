// pathfinder/shaders/gles2/mcaa-cover.vs.glsl
//
// Copyright (c) 2017 The Pathfinder Project Developers.
//
// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

precision highp float;

uniform vec4 uTransformST;
uniform vec4 uHints;
uniform ivec2 uFramebufferSize;
uniform ivec2 uPathTransformSTDimensions;
uniform sampler2D uPathTransformST;

attribute vec2 aQuadPosition;
attribute vec2 aUpperLeftPosition;
attribute vec2 aLowerRightPosition;
attribute float aPathID;

varying vec2 vHorizontalExtents;

void main() {
    int pathID = int(aPathID);

    vec4 transformST = fetchFloat4Data(uPathTransformST, pathID, uPathTransformSTDimensions);

    vec2 upperLeftPosition = computeMCAAPosition(aUpperLeftPosition,
                                                 uHints,
                                                 transformST,
                                                 uTransformST,
                                                 uFramebufferSize);
    vec2 lowerRightPosition = computeMCAAPosition(aLowerRightPosition,
                                                  uHints,
                                                  transformST,
                                                  uTransformST,
                                                  uFramebufferSize);

    vHorizontalExtents = vec2(upperLeftPosition.x, lowerRightPosition.x);

    vec4 extents = vec4(upperLeftPosition.x, ceil(upperLeftPosition.y), lowerRightPosition);
    vec2 position = computeXCAAClipSpaceQuadPosition(extents, aQuadPosition, uFramebufferSize);
    float depth = convertPathIndexToViewportDepthValue(pathID);

    gl_Position = vec4(position, depth, 1.0);
}
