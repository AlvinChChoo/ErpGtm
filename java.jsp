<%@ page
   import="javax.xml.parsers.*, org.w3c.dom.*"
%>

<%
   // load and parse the document
   DocumentBuilder builder;
   DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
   builder = factory.newDocumentBuilder();
   Document document = builder.parse("C:/cnmig/xmldom/xml/hello.xml");

   // retrieve and display Hello World!
   Element root = document.getDocumentElement();
   Node text = root.getFirstChild();
%>

<html>
   <body>
      <p><%=text.getNodeValue() %></p>
   </body>
</html>

