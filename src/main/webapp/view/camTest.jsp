<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Display Webcam Stream</title>
 
<style>
#container {
	margin: 0px auto;
	width: 500px;
	height: 375px;
	border: 10px #333 solid;
}
#videoElement {
	width: 500px;
	height: 375px;
	background-color: #666;
}
</style>




</head>
 
<body>
	<div id="container">
		<video autoplay="true" id="videoElement">
		
		</video>
	</div>
	
	<button id="stop" onclick="stop()">stop</button>
	
	<script type="text/javascript">

	
	var video = document.querySelector("#videoElement");
	
	if (navigator.mediaDevices.getUserMedia) {
	  navigator.mediaDevices.getUserMedia({ video: true })
	    .then(function (stream) {
	      video.srcObject = stream;
	    })
	    .catch(function (err0r) {
	      console.log("Something went wrong!");
	    });
	}

	function stop(e) {
		  var stream = video.srcObject;
		  var tracks = stream.getTracks();

		  for (var i = 0; i < tracks.length; i++) {
		    var track = tracks[i];
		    track.stop();
		  }

		  video.srcObject = null;
	}
	</script>
</body>
</html>