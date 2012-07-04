<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLConnection"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%!
	//TODO find it using System.getProperty()?
	private final static String CURRENT_DIR = "/Users/sergeikirsanov/Documents/projects/cmd113/WebContent/";
	
	static {
		loadAvailableCommands();
	}
	
	private static Map<String, String> commands;

	private synchronized static void loadAvailableCommands() {
		commands = new HashMap<String, String>();

		File workingDir = new File(CURRENT_DIR);
		for (String cmdPath : workingDir.list()) {
			if (cmdPath.endsWith(".jsp") && !"cmd.jsp".equalsIgnoreCase(cmdPath)) {
				commands.put(cmdPath.replaceFirst("(.*)\\.jsp", "$1"), cmdPath);
			}
		}
		System.out.println(commands);
	}%>
<%
	String cmdLine = request.getParameter("cmd");

	if (cmdLine != null) {
		String action = request.getParameter("action");
		if(action != null && "tab".equalsIgnoreCase(action)) {
			for(String command : commands.keySet()) {
				if(command.startsWith(cmdLine)) {
				out.println(command);
				}
			}

			return; 
		}
		
		if("@init".equalsIgnoreCase(cmdLine)) {
			loadAvailableCommands();
			return;
		}

		
		//TODO support strings within quotes: ""
		String args[] = cmdLine.split("[ ]+");
		if (!commands.containsKey(args[0])) {
			out.println(args[0] + ": command not found");
			return;
		}

		StringBuffer urlBuffer = new StringBuffer(
				"http://localhost:8080/cmd113/");
		urlBuffer.append(args[0]);
		urlBuffer.append(".jsp?action=exec");

		//TODO apache HTTP client?
		//TODO maven for dependencies?
		for (int i = 1; i < args.length; i++) {
			if (args[i].startsWith("--")) {
				urlBuffer.append("&flags=")
						.append(args[i].substring(2));
			} else if (args[i].startsWith("-")) {
				urlBuffer.append("&").append(args[i].substring(1)).append("=");
			} else {
				urlBuffer.append(args[i]);
			}
		}

		System.out.println(urlBuffer.toString());

		URL url = new URL(urlBuffer.toString());
		URLConnection conn = url.openConnection();

		BufferedReader rd = new BufferedReader(new InputStreamReader(
				conn.getInputStream()));
		//StringBuffer sb = new StringBuffer();
		String line;
		while ((line = rd.readLine()) != null) {
			//	sb.append(line);
			out.println(line);
		}
		rd.close();

	} else {
%>
<html>
<head>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"
	type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8">
	$(document).ready(function(){
		$("#input-cmd").focus();
		
		$("#input-cmd").live('keydown',function(e) {
			var keyCode = (e.keyCode ? e.keyCode : e.which);
			if (keyCode == 9) { //TAB
			    e.preventDefault(); 				

				sendCommand('tab', false);
		 	} 
		});
	});
	
	$("html").click(function (e)
	{
		$("#input-cmd").focus();
	});
	
		
	function sendCommand(actionVal, showEmpty) {
		var cmdVal = $("#input-cmd").val();
		if(showEmpty) {
			$("#input-cmd").val('');
		}
		$.ajax({
			type : 'POST',
			
			/* direct call to command may be used here, but I filter 
			   it with current jsp to allow referring to JSPs 
			   not from current folder by means of cmd.properties file. */
			url : '/cmd113/cmd.jsp',
			data : {
				cmd : cmdVal,
				action: actionVal
			},
			success : function(data) {
				if(showEmpty || $.trim(data)) {							

					$("#input-line").before("<tr><td><table><tr><td>&gt;</td><td>"+cmdVal+"</td></tr></table></td></tr>"+
					"<tr><td>"+data+"</td></tr>");
				
					//scroll down
					$(document).scrollTop($(document).height());			
				}
			},
			error : function(data) {
				alert("Error");
			}
		});			
	};
</script>
<style type="text/css">
* {
	margin: 0; padding: 0;
	background-color: #000;
	font-weight: normal;
	font-size: 10pt;
	font-family: fixedsys, courier new, courier, verdana, helvetica, arial, sans-serif;
	color: #bbbbbb;
}

#input-cmd {
	margin: 0;
	padding: 0;
	padding: 0 1px 0 0;
	vertical-align: middle;
	text-align: left;
	width: 100%;
	border: 0;
	/* "outline: none;" - removing the blue glow in Safari */
	outline: none;
}
</style>
</head>
<body>
	<table id="cmd-table">		
		<tr id="input-line">
			<td>
				<table>
					<tr>
						<td>&gt;</td>
						<td>
							<form method="post" autocomplete="off" action="#"
								onsubmit="sendCommand('',true);return false">
								<input id="input-cmd" type="text" autocomplete="off" />
							</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>
<%
}
%>

