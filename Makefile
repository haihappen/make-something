path := $(shell read -p "What is your project called? " path; echo $$path)


define GIT_IGNORE
bundle/
node_modules/
endef

export GIT_IGNORE
$(path):
	mkdir -p $(path)
	git init $(path)
	echo "$$GIT_IGNORE" > $(path)/.gitignore
	cd $(path); git add .gitignore; git commit -m "Set up repository"


$(path)/package.json:
	cd $(path); npm init -y


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

export INDEX_HTML
$(path)/index.html:
	echo "$$INDEX_HTML" > $(path)/index.html


define INDEX_JS
import React from "react";
import ReactDOM from "react-dom";

ReactDOM.render(<h1>Make something!</h1>, document.querySelector("main"));
endef

export INDEX_JS
$(path)/index.js:
	echo "$$INDEX_JS" > $(path)/index.js


define WEBPACK_CONFIG
module.exports = {
  entry: "./index.js",
  output: {
    path: __dirname + "/bundle",
    filename: "$(path).js",
    publicPath: "bundle"
  },
  module: {
    loaders: [
      { test: /\.jsx?$$/, exclude: /node_modules/, loader: "babel?presets[]=es2015&presets[]=stage-0&presets[]=react" }
    ]
  }
};
endef

export WEBPACK_CONFIG
$(path)/webpack.config.js:
	echo "$$WEBPACK_CONFIG" > $(path)/webpack.config.js
	cd $(path); npm install --save react react-dom
	cd $(path); npm install --save-dev webpack webpack-dev-server babel-loader babel-preset-es2015 babel-preset-react babel-preset-stage-0
	cd $(path); git add .; git commit -m "Add React"


something: $(path) $(path)/package.json $(path)/index.html $(path)/index.js $(path)/webpack.config.js
