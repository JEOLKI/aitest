<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Detect Faces Sample</title>
	<link rel="stylesheet" href="main.css" type="text/css" media="all">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="capture.js">
	</script>




<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
</head>
<body>

<div class="contentarea">
	<h1>
		MDN - WebRTC: Still photo capture demo
	</h1>
	<p>
		This example demonstrates how to set up a media stream using your built-in webcam, fetch an image from that stream, and create a PNG using that image.
	</p>
  <div class="camera">
    <video id="video">Video stream not available.</video>
    <button id="startbutton">Take photo</button> 
  </div>
  <canvas id="canvas">
  </canvas>
  <div class="output">
    <img id="photo" alt="The screen capture will appear in this box."> 
  </div>
	<p>
		Visit our article <a href="https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Taking_still_photos"> Taking still photos with WebRTC</a> to learn more about the technologies used here.
	</p>
	
	<div id="imgurl">
	
	</div>
	
</div>

	<script type="text/javascript">
		function processImage() {
			var subscriptionKey = "cae766a534074d6b89f02281da4e14cf";
			var uriBase = "https://faceanalysis-jh.cognitiveservices.azure.com/face/v1.0/detect";
			// Request parameters.
			var params = {
				"detectionModel" : "detection_01",
				"returnFaceAttributes": "age,gender,headPose,smile,facialHair,glasses,emotion,hair,makeup,occlusion,accessories,blur,exposure,noise",
				"returnFaceId" : "true"
			};
			// Display the image.
			var sourceImageUrl = document.getElementById("inputImage").value;
			document.querySelector("#sourceImage").src = sourceImageUrl;
			// Perform the REST API call.
			$.ajax({
								url : uriBase + "?" + $.param(params),
								// Request headers.
								processData: false,
								beforeSend : function(xhrObj) {
									xhrObj.setRequestHeader("Content-Type",
											"application/octet-stream");
									xhrObj.setRequestHeader(
											"Ocp-Apim-Subscription-Key",
											subscriptionKey);
								},
								type : "POST",
								
								// Request body.
								data : makeblob($('#inputImage').val()),
							})
					.done(
							function(data) {
								// Show formatted JSON on webpage.
								$("#responseTextArea").val(
										JSON.stringify(data, null, 2));
							})
					.fail(
							function(jqXHR, textStatus, errorThrown) {
								// Display error message.
								var errorString = (errorThrown === "") ? "Error. "
										: errorThrown + " (" + jqXHR.status
												+ "): ";
								errorString += (jqXHR.responseText === "") ? ""
										: (jQuery.parseJSON(jqXHR.responseText).message) ? jQuery
												.parseJSON(jqXHR.responseText).message
												: jQuery
														.parseJSON(jqXHR.responseText).error.message;
								alert(errorString);
							});
		};


		makeblob = function (dataURL) {
            var BASE64_MARKER = ';base64,';
            if (dataURL.indexOf(BASE64_MARKER) == -1) {
                var parts = dataURL.split(',');
                var contentType = parts[0].split(':')[1];
                var raw = decodeURIComponent(parts[1]);
                return new Blob([raw], { type: contentType });
            }
            var parts = dataURL.split(BASE64_MARKER);
            var contentType = parts[0].split(':')[1];
            var raw = window.atob(parts[1]);
            var rawLength = raw.length;

            var uInt8Array = new Uint8Array(rawLength);

            for (var i = 0; i < rawLength; ++i) {
                uInt8Array[i] = raw.charCodeAt(i);
            }

            return new Blob([uInt8Array], { type: contentType });
        }
		
	</script>



	<h1>Detect Faces:</h1>
	Enter the URL to an image that includes a face or faces, then click the
	<strong>Analyze face</strong> button.
	<br>
	<br> Image to analyze:
	<input type="text" name="inputImage" id="inputImage"
		value="" />
	<button onclick="processImage()">Analyze face</button>
	<br>
	<br>
	<div id="wrapper" style="width: 1020px; display: table;">
		<div id="jsonOutput" style="width: 600px; display: table-cell;">
			Response:<br>
			<br>
			<textarea id="responseTextArea" class="UIInput"
				style="width: 580px; height: 400px;"></textarea>
		</div>
		<div id="imageDiv" style="width: 420px; display: table-cell;">
			Source image:<br>
			<br> <img id="sourceImage" width="400" />
		</div>
	</div>


</body>
</html>