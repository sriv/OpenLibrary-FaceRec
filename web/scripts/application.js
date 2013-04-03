function UserViewModel()
{
  var self = this,
  context,
  canvas,
  highlightClassNames = {'user': ['active',null,null], 'book': ['done','active',null], 'confirmation': ['done', 'done', 'active']},
  sections = $("div.section");

  self.getElement = function(elements, cssSelector) {
    return $.grep(elements, function(element) { return $(element).hasClass(cssSelector); })[0];
  };

  self.bookEl = self.getElement(sections, "book");
  self.userEl = self.getElement(sections, "user");
  self.confirmationEl = self.getElement(sections, "confirmation");

  self.userData = ko.observable();
  self.validUser = ko.observable(true);
  self.setUserData = function(data){
    self.userData(JSON.parse(data));
    self.validUser(true);
    self.focus(self.bookEl);
  }

  self.invalidUser = function(message){
    self.validUser(false);
    self.setErrorMessage(message);
  }


  self.init = function() {
    window.addEventListener("DOMContentLoaded", function() {
    var video = $("#video")[0],
      videoObj = { "video": true },
      errorHandler = function(error) {
        console.log("Video capture error: ", error.code); 
      };
      canvas = $("#canvas")[0];
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

  self.reserveBook = function() {
    var isbnInput = $("#isbn");
    var employeeId = this.userData().employee_id; 
    $(document).ajaxError(self.failureMessage);
    $.post("/reserve", {
        type: "data", 
        employeeId: employeeId,
        isbn: isbnInput[0].value
      }, self.reserveSuccessful());
    this.focus(this.confirmationEl);
  }

  self.reserveSuccessful = function() {
    return function(message){
      self.setSuccessMessage(message);
      $.get("/user?employee_id=" + self.userdata().employee_id, self.setUserData)
    };
  }

  self.notify = function (message, type) {
    $.notifyBar({
      html: message,
      delay: 5000,
      cls: type,
      animationSpeed: "normal"
    });  
  }

  self.failureMessage = function(event, jqxhr, settings, exception){
    self.setErrorMessage(jqxhr.responseText);
  }

  self.setErrorMessage = function(message){
    self.notify(message, "error");
  }  

  self.setSuccessMessage = function(message){
    self.notify(message, "success");
  }  

  self.highlightHelp = function() {
    var currentSection = $('div.section:visible').attr("data-section-name");

    var sectionClassNames = highlightClassNames[currentSection];
    $("div.help .notes").each(function(index, element) {
      $(element).removeClass('active done').addClass(sectionClassNames[index]);
    });
  }

  self.focus = function(section) {
    var deFocusedElements = [self.userEl, self.bookEl, self.confirmationEl].filter(function(element) { return element != section; });
    deFocusedElements.forEach(function(element){ $(element).hide(); });
    $(section).fadeIn();
    self.highlightHelp();
    $(section).find("input.barcode").focus();
  };

  self.init();
}


$(document).ready(function(){
  ko.applyBindings(new UserViewModel());
});

