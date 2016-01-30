path := $(shell read -p "What is your project called? " path; echo $$path)


git:
	mkdir -p $(path)
	git init $(path)


export GIT_IGNORE INDEX_HTML INDEX_JS WEBPACK_CONFIG
react: git
react:
	cd $(path); npm init -y
	echo "$$GIT_IGNORE" > $(path)/.gitignore
	echo "$$INDEX_HTML" > $(path)/index.html
	echo "$$INDEX_JS" > $(path)/index.js
	echo "$$WEBPACK_CONFIG" > $(path)/webpack.config.js

	cd $(path); npm install --save react react-dom
	cd $(path); npm install --save-dev webpack webpack-dev-server babel-loader babel-preset-es2015 babel-preset-react babel-preset-stage-0
	cd $(path); git add .
	cd $(path); git commit -m "Set up repository"


something: react


define GIT_IGNORE
bundle/
node_modules/
endef


define INDEX_HTML
<!DOCTYPE html>
<html lang="en">
  <head><meta charset="UTF-8" />
  <title>$(path)</title>
</head>
<body>
  <main></main>
  <script src="bundle/$(path).js"></script>
</body>
</html>
endef


define INDEX_JS
import React from "react";
import ReactDOM from "react-dom";


ReactDOM.render(<h1>Make something!</h1>, document.querySelector("main"));
endef


define WEBPACK_CONFIG
module.exports = {
  entry: "./index.js",
  output: {
    path: __dirname + "/bundle",
    filename: "$(path).js"
  },
  module: {
    loaders: [
      { test: /\.jsx?$$/, exclude: /node_modules/, loader: "babel?presets[]=es2015&presets[]=stage-0&presets[]=react" }
    ]
  }
};
endef
