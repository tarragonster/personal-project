const express = require("express");
const app = express();
const fs = require("fs");
const path = require('path'); // https://stackoverflow.com/questions/58801984/referenceerror-path-is-not-defined-express

app.get("/", function (req, res) {
  res.sendFile(__dirname + "/index.html");
});

app.get("/video", function (req, res) {
  // Ensure there is a range given for the video
  const range = req.headers.range;
  console.log({range})
  if (!range) {
    res.status(400).send("Requires Range header");
  }

  // get video stats (about 61MB)
  const videoPath = "./src/bigbuck.mp4";
  console.log(videoPath)
  const videoSize = fs.statSync("./src/bigbuck.mp4").size; // is used to synchronously return information about the given file path // https://www.geeksforgeeks.org/node-js-fs-statsync-method/
  console.log({videoSize})
  // Parse Range
  // Example: "bytes=32324-"
  const CHUNK_SIZE = 10 ** 6; // 1MB
  const start = Number(range.replace(/\D/g, "")); // replace text
  console.log({start})
  const end = Math.min(start + CHUNK_SIZE, videoSize - 1);
  console.log({end})

  // Create headers
  const contentLength = end - start + 1;
  console.log({contentLength})
  const headers = {
    "Content-Range": `bytes ${start}-${end}/${videoSize}`, // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Range
    "Accept-Ranges": "bytes",
    "Content-Length": contentLength,
    "Content-Type": "video/mp4",
  };

  // HTTP Status 206 for Partial Content
  res.writeHead(206, headers);

  // create video read stream for this particular chunk
  const videoStream = fs.createReadStream(videoPath, { start, end });

  // Stream the video chunk to the client
  videoStream.pipe(res);
});

app.listen(3000, function () {
  console.log("Listening on port 3000!");
});