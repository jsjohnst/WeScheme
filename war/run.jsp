<%-- Runs a program
     Url scheme:

     http://www.wescheme.org/run/public-url
--%>

<%
String url = request.getRequestURL().toString();
String publicId = url.substring(url.lastIndexOf("/") + 1);
%>


<html>
<head>
<title>WeScheme</title>
<script src="/editor/jquery.js"></script>
<script src="/editor/jquery.createdomnodes.js"></script>
<jsp:include page="/moby-runtime-includes.jsp" />
<script src="/runtime/permission-struct.js"></script>
<script src="/openEditor/interaction.js"></script>




<script>

function Runner(interactionsDiv) {
    this.namespace = new Namespace();
    this.interactionsDiv = jQuery(interactionsDiv);
}


Runner.prototype._prepareToRun = function() {
    var that = this;
    plt.world.MobyJsworld.makeToplevelNode = function() {
	var area = jQuery("<div></div>");
	that.interactionsDiv.append(area);
	return area.get(0);
    };
}


Runner.prototype.runCompiledCode = function(compiledCode, permStringArray) {
    var that = this;
    this._prepareToRun();
//    try {
	for (var i = 0; i < permStringArray.length; i++) {
	    var perm = symbol_dash__greaterthan_permission(permStringArray[i]);
	    plt.permission.runStartupCode(perm);
	}
//	var runToplevel = this.namespace.eval(compiledCode, '42');
// 	runToplevel(function(val) {
// 	    if (val != undefined) {
// 		that.addToInteractions(plt.Kernel.toDomNode(val) + "\n");
// 	    }
// 	});





(function() { 
    ((function (toplevel_dash_expression_dash_show0) { 
	toplevel_dash_expression_dash_show0(
	    (plt.Kernel.setLastLoc("offset=0 line=1 span=32 id=\"\"") &&
	     plt.world.MobyJsworld.bigBang((plt.types.Rational.makeInstance(0, 1)),
					   (plt.Kernel.setLastLoc("offset=15 line=1 span=16 id=\"\"")   &&
					    plt.world.config.Kernel.onTick((plt.types.Rational.makeInstance(1, 1)),
									   (function() { var result = (function(args) {
									       return plt.Kernel.add1(args[0]);
									   });
											 result.toWrittenString = function() {return '<function:add1>'; }
											 result.toDisplayedString = function() {return '<function:add1>';}
											 return result; })())), []))); }))(plt.Kernel.identity)
})();
    
    




//    } catch (err) {
//	this.addToInteractions(err.toString() + "\n");
//	throw err;
//    }
}


Runner.prototype.addToInteractions = function (interactionVal) {
    if (interactionVal instanceof Element ||
	interactionVal instanceof Text) {
	this.interactionsDiv.append(interactionVal);
    } else {
	var newArea = jQuery("<div style='width: 100%'></div>");
	newArea.text(interactionVal);
	this.interactionsDiv.append(newArea);
	}
    this.interactionsDiv.attr("scrollTop", this.interactionsDiv.attr("scrollHeight"));
};






function init() { 
    var interactions = 
	new Runner(document.getElementById('interactions'));

    var data = { publicId: "<%= publicId %>" };
    var type = "xml";
    var callback = function(data) {
        var dom = jQuery(data);
	var program = dom.find("ObjectCode").find("obj").text();
	var permissions = [];
	dom.find("ObjectCode").
	    find("permissions").
	    find("permission").
	    each(function() { 
		permissions.push(plt.Kernel.string_dash__greaterthan_symbol(jQuery(this).text())); });
	console.log(permissions);
	interactions.runCompiledCode(program, permissions);
    };
    jQuery.get("/loadProject", data, callback, type);
}
</script>





</head>




<body onload="init()">
<div id="interactions">
</div>

</body>
</html>