function UserViewModel()
{
  var self = this;
  var context;
  var canvas;
  self.userData = ko.observable();
  self.validUser = ko.observable(true);
  self.setUserData = function(data){
    self.userData(JSON.parse(data));
    self.validUser(true);
  }
  self.invalidUser = function(){
    console.log("invalid user");
    self.validUser(false);
  }


  self.init = function() {
    window.addEventListener("DOMContentLoaded", function() {
    var video = document.getElementById("video"),
      videoObj = { "video": true },
      errorHandler = function(error) {
        console.log("Video capture error: ", error.code); 
      };
      canvas = document.getElementById("canvas");
      context = canvas.getContext("2d");
      context.fillStyle = "rgba(0, 0, 200, 0.5)";
      if(navigator.getUserMedia) { // Standard
      navigator.getUserMedia(videoObj, function(stream) {
        video.src = stream;
        video.play();
        self.processWebcamVideo(context);
      }, errorHandler);
      } else if(navigator.webkitGetUserMedia) {
      navigator.webkitGetUserMedia(videoObj, function(stream){
        video.src = window.webkitURL.createObjectURL(stream);
        video.play();
        self.processWebcamVideo(context);
      }, errorHandler);
      }        
      }, false);
  };

  self.processWebcamVideo = function() {
    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    var faces = self.detectFaces();

    if(faces.length>0)
      self.identifyUser(faces[0]);
    else
      setTimeout(self.processWebcamVideo, 50);
  };

  self.detectFaces = function() {
    return ccv.detect_objects({canvas : (ccv.pre(canvas)), cascade: cascade, interval: 2, min_neighbors: 1});
  };

  self.identifyUser = function(face) {
    $.post("/recognize", {
        type: "data", 
        image: canvas.toDataURL("image/png")
      }, self.setUserData)
    .fail(self.invalidUser);
  };

  self.init();
}


$(document).ready(function(){
  ko.applyBindings(new UserViewModel());
});

