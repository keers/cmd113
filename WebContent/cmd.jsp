
<%
String cmd = request.getParameter("cmd");

if(cmd != null)
{
	System.out.println("SEKI:: " + cmd);
	out.println("result from : " + cmd);	
}
else 
{
%>
<html>
<head>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"
	type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8">
	$(document).ready(function(){
		$("#input-cmd").focus();
	});
	
	$("html").click(function (e)
	{
		$("#input-cmd").focus();
	});
	
	function sendCommand() {
		var cmdVal = $("#input-cmd").val();
		$("#input-cmd").val('');
		$.ajax({
			type : 'POST',
			url : '/cmd113/proc.jsp',
			data : {
				cmd : cmdVal
			},
			success : function(data) {
				$("#input-line").before("<tr><td><table><tr><td>&gt;</td><td>"+cmdVal+"</td></tr></table></td></tr>"+
				"<tr><td>"+data+"</td></tr>");
				//scroll down
				$(document).scrollTop($(document).height());
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
								onsubmit="sendCommand();return false">
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

