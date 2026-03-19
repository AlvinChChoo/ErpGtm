<%@ Page Language="vb" Debug="true" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Configuration" %>
<script runat="server">

    Dim id As String
         Dim formName As String
         Dim postBack As String

         Private Sub Page_Load(sender As Object, e As System.EventArgs)



            id  = Request.QueryString("id")
            formname = Request.QueryString("formName")
            postBack = Request.QueryString("postBack")

             response.write(id)
             response.write(",")

             response.write(formName)
             response.write(",")

             response.write(postback)
             response.write(",")


             'cmdYes.Attributes.Add("onClick","KeyDownHandler1(cmdBack)")
             'Dim id as string = "cmdBack"
             'Dim PostBack as string = "true"
             'Dim form As String = "test11"
             'cmdYes.Attributes.Add("onClick", "window.opener.SetDate('" + form + "','" + id + "', document.Calendar.datechosen.value," + postBack + ");")

             cmdYes.Attributes.Add("onClick", "window.opener.KeyDownHandler1('" + formName + "','" + id + "', document.Calendar.datechosen.value," + postBack + ");")

             'cmdYes.Attributes.Add("onClick", "window.opener.KeyDownHandler1('" + form + "','" + id + "'," + postBack + ");")
             cmdNo.Attributes.Add("onClick", "CloseWindow()")
             'cmdYes.Attributes.Add("onClick", "window.opener.SetDate('" + form + "','" + id + "', document.Calendar.datechosen.value," + postBack + ");")
             'cmdNo.Attributes.Add("onClick", "CloseWindow()")
             'response.write ("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR")
             'If Not Page.IsPostBack Then
         '        Dim id As String = Request.QueryString("id")
         '        Dim form As String = Request.QueryString("formname")
         '        Dim postBack As String = Request.QueryString("postBack")

                 'Cal.SelectedDate = now.toShortDateString
                 'FillCalendarChoices()
                 'SelectCorrectValues()
                 'OKButton.Attributes.Add("onClick", "window.opener.SetDate('" + form + "','" + id + "', document.Calendar.datechosen.value," + postBack + ");")
                 'CancelButton.Attributes.Add("onClick", "CloseWindow()")
             'End If

         End Sub

         Sub cmdYes_Click(sender As Object, e As EventArgs)



         End Sub

         Sub Button1_Click(sender As Object, e As EventArgs)
             datechosen.Value = textbox1.text
         End Sub

</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>Calendar</title>
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
    <script language="javascript">
            function CloseWindow()
            {
                self.close();
            }




        </script>
</head>
<body bgcolor="#ffffff" leftmargin="5" topmargin="5">
    <form id="Calendar" method="post" runat="server">
        <p>
            <asp:Button id="cmdYes" onclick="cmdYes_Click" runat="server" Text="yes" Width="40px"></asp:Button>
            &nbsp;&nbsp;
            <asp:Button id="cmdNo" runat="server" Text="no" Width="40px"></asp:Button>
            <input id="datechosen" type="hidden" name="datechosen" runat="server" />
        </p>
        <p>
            <asp:TextBox id="TextBox1" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Button"></asp:Button>
        </p>
    </form>
</body>
</html>
