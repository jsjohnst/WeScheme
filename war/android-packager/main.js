var main = {};


(function() {

    main.onload = function() {
	document.getElementById("loading").style['display'] = "none";

	var onSuccess = function() {}
	var onFail = function(err) { reportError(err); }
	evaluator.executeCompiledProgram(program.bytecode,
					 onSuccess,
					 onFail);
    }; 

    main.onunload = function() {
	evaluator.requestBreak();
    };



    //////////////////////////////////////////////////////////////////////

    var evaluator = new Evaluator(
	{ write: function(x) { writeToInteractions(x) },
	  writeError: function(err) { reportError(err) },
	});

    evaluator.makeToplevelNode = function() {
	var jsworldDiv = document.getElementById("jsworld-div");

	var dom = document.createElement("div");
	var innerDom = document.createElement("div");
	dom.appendChild(innerDom);
	jsworldDiv.appendChild(dom);

	return innerDom;
    };


    var writeToInteractions = function(thing) {
	var interactionsDiv = document.body;
	if (typeof thing === 'string' || typeof thing === 'number') {
	    var dom = document.createElement('div');
	    dom.style['white-space'] = 'pre';
	    dom.appendChild(document.createTextNode(thing + ''));
	    interactionsDiv.appendChild(dom);
	} else {
	    interactionsDiv.appendChild(thing);
	    // IE Hack for excanvas elements.
	    // See: http://www.lrbabe.com/?p=104
	    // The issue is that if we use excanvas, and it has
	    // vml, things don't render if the element hasn't been
	    // attached to the dom.  Ugly stuff.
	    if (/MSIE/.test(navigator.userAgent) && !window.opera) {
		setTimeout(function() { thing.outerHTML = thing.outerHTML; },
			   0);
	    }
	}
    };


    var reportError = function(exn) {
	// Under google-chrome, this will produce a nice error stack
	// trace that we can deal with.
	if (typeof(console) !== 'undefined' && console.log &&
	    exn && exn.stack) {
	    console.log(exn.stack);
	}

	var domElt = document.createElement('div');
	domElt.style['color'] = 'red';
	domElt.appendChild(document.createTextNode(evaluator.getMessageFromExn(exn)+""));

	var stacktrace = evaluator.getTraceFromExn(exn);
	for (var i = 0; i < stacktrace.length; i++) {
	    domElt.appendChild(document.createElement("br"));
	    domElt.appendChild(document.createTextNode(
		"in " + stacktrace[i].id +
		    ", at offset " + stacktrace[i].offset +
		    ", line " + stacktrace[i].line +
		    ", column " + stacktrace[i].column +
		    ", span " + stacktrace[i].span));
	};

	writeToInteractions(domElt);
    };


})();
