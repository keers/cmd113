<%!
private static final String VERSION = "0.1";
%>
<%
	//parsing --help and --version
	String[] flags = request.getParameterValues("flags");

	if (flags != null) {
		for (String flag : flags) {
	if ("version".equalsIgnoreCase(flag)) {
		out.println("Version: " + VERSION + "<br/>");
		out.println("Author: SEKI0709");
	} else if ("help".equalsIgnoreCase(flag)) {
		out.println("Usage:<p>");
		out.println("<table>");
		out.println("<tr><td>--help</td><td>- show this help</td></tr>");
		out.println("<tr><td>--version</td><td>- show current version</tr>");
		out.println("</table>");
	}
		}
	}
	
	String nameFilter = request.getParameter("n");
	if (nameFilter != null) {
		out.println("params will use -n search filter: " + nameFilter);
	}
%>