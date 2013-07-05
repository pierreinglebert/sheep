define(function(require) {
  var sheep;
  sheep = require('cs!sheep/core');
  sheep.DisplayObject = require('cs!sheep/drawable/displayObject');
  sheep.Rectangle = require('cs!sheep/drawable/rectangle');
  sheep.Circle = require('cs!sheep/drawable/circle');
  sheep.Bitmap = require('cs!sheep/drawable/bitmap');
  sheep.Container = require('cs!sheep/drawable/container');
  sheep.World = require('cs!sheep/drawable/world');
  sheep.Ticker = require('cs!sheep/ticker');
  return sheep;
});
