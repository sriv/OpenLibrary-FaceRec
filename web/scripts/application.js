var context;
var canvas;
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
      processWebcamVideo(context);
    }, errorHandler);
    } else if(navigator.webkitGetUserMedia) {
    navigator.webkitGetUserMedia(videoObj, function(stream){
      video.src = window.webkitURL.createObjectURL(stream);
      video.play();
      processWebcamVideo(context);
    }, errorHandler);
    }        
}, false);

function processWebcamVideo() {
  var startTime = +new Date(),
      changed = false,
      scaleFactor = 1,
      faces;

  context.drawImage(video, 0, 0, canvas.width, canvas.height);
  faces = detectFaces();

  if(faces.length>0)
    identifyUser(faces[0]);
  else
    setTimeout(processWebcamVideo, 50);
}

function detectFaces() {
  return ccv.detect_objects({canvas : (ccv.pre(canvas)), cascade: cascade, interval: 2, min_neighbors: 1});
}

function identifyUser(face) {
  $.post("/recognize", {
      type: "data", 
      image: canvas.toDataURL("image/png")
    }, function (data, textStatus, jqXHR) { $('#identifiedUser').text(data);});
}
