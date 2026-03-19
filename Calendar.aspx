<%@ Page Language="vb" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Configuration" %>
<script runat="server">

    Private Sub Page_Load(sender As Object, e As System.EventArgs)
        If Not Page.IsPostBack Then
            Dim id As String = Request.QueryString("id")
            Dim form As String = Request.QueryString("formname")
            Dim postBack As String = Request.QueryString("postBack")
    
            Cal.SelectedDate = now.toShortDateString
            FillCalendarChoices()
            SelectCorrectValues()
            OKButton.Attributes.Add("onClick", "window.opener.SetDate('" + form + "','" + id + "', document.Calendar.datechosen.value," + postBack + ");")
            CancelButton.Attributes.Add("onClick", "CloseWindow()")
        End If
    End Sub
    
    Private Sub FillCalendarChoices()
        Dim thisdate As New DateTime(DateTime.Today.Year, 1, 1)
        Dim x As Integer
        Dim y As Integer
    
        For x = 0 To 11
            Dim li As New ListItem(thisdate.ToString("MMMM"), thisdate.Month.ToString())
            MonthSelect.Items.Add(li)
            thisdate = thisdate.AddMonths(1)
        Next x
    
        For y = 1994 To thisdate.Year
            YearSelect.Items.Add(y.ToString())
        Next y
    End Sub
    
    
    Private Sub SelectCorrectValues()
        lbldate.text = cal.selecteddate
        datechosen.Value = lblDate.Text
        MonthSelect.SelectedIndex = MonthSelect.Items.IndexOf(MonthSelect.Items.FindByValue(Cal.SelectedDate.Month.ToString()))
        YearSelect.SelectedIndex = YearSelect.Items.IndexOf(YearSelect.Items.FindByValue(Cal.SelectedDate.Year.ToString()))
    End Sub
    
    Private Sub Cal_SelectionChanged(sender As Object, e As System.EventArgs)
        Cal.VisibleDate = Cal.SelectedDate
        SelectCorrectValues()
    End Sub
    
    Private Sub MonthSelect_SelectedIndexChanged(sender As Object, e As System.EventArgs)
        Cal.VisibleDate = New DateTime(Convert.ToInt32(YearSelect.SelectedItem.Value), Convert.ToInt32(MonthSelect.SelectedItem.Value), 1)
        Cal.SelectedDate = Cal.VisibleDate
        SelectCorrectValues()
    End Sub 'MonthSelect_SelectedIndexChanged
    
    Private Sub YearSelect_SelectedIndexChanged(sender As Object, e As System.EventArgs)
        Cal.VisibleDate = New DateTime(Convert.ToInt32(YearSelect.SelectedItem.Value), Convert.ToInt32(MonthSelect.SelectedItem.Value), 1)
        Cal.SelectedDate = Cal.VisibleDate
        SelectCorrectValues()
    End Sub 'YearSelect_SelectedIndexChanged
    
    Sub OKButton_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub CancelButton_Click(sender As Object, e As EventArgs)
    End Sub

</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>Calendar</title> 
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="styles.css" type="text/css" rel="stylesheet" />
    <script language="javascript">
            function CloseWindow()
            {
                self.close();
            }
        </script>
</head>
<body bgcolor="#ffffff" leftmargin="5" topmargin="5">
    <form id="Calendar" method="post" runat="server">
        <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tbody>
                <tr bgcolor="white">
                    <td colspan="2">
                        <img height="10" src="images/spacer.gif" width="1" /></td>
                </tr>
                <tr bgcolor="white">
                    <td align="middle" colspan="2">
                        <asp:dropdownlist id="MonthSelect" runat="server" CssClass="standard-text" Height="22px" Width="90px" AutoPostBack="True" OnSelectedIndexChanged="MonthSelect_SelectedIndexChanged"></asp:dropdownlist>
                        &nbsp; 
                        <asp:dropdownlist id="YearSelect" runat="server" CssClass="standard-text" Height="22px" Width="60px" AutoPostBack="True" OnSelectedIndexChanged="YearSelect_SelectedIndexChanged"></asp:dropdownlist>
                        <asp:calendar id="Cal" runat="server" CssClass="standard-text" BorderWidth="5px" ShowTitle="False" ShowNextPrevMonth="False" BorderStyle="Solid" Font-Size="XX-Small" Font-Names="Arial" BorderColor="White" DayNameFormat="FirstTwoLetters" ForeColor="#C0C0FF" FirstDayOfWeek="Monday" OnSelectionChanged="Cal_SelectionChanged">
                            <todaydaystyle font-bold="True" forecolor="White" backcolor="#990000"></todaydaystyle>
                            <daystyle borderwidth="2px" forecolor="#666666" borderstyle="Solid" bordercolor="White" backcolor="#EAEAEA"></daystyle>
                            <dayheaderstyle forecolor="#649CBA"></dayheaderstyle>
                            <selecteddaystyle font-bold="True" forecolor="#333333" backcolor="#FAAD50"></selecteddaystyle>
                            <weekenddaystyle forecolor="White" backcolor="#BBBBBB"></weekenddaystyle>
                            <othermonthdaystyle forecolor="#666666" backcolor="White"></othermonthdaystyle>
                        </asp:calendar>
                    </td>
                </tr>
                <tr>
                    <td align="middle" colspan="2">
                        Date Selected: <asp:Label id="lblDate" runat="server"></asp:Label>
                        <input id="datechosen" type="hidden" name="datechosen" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <img height="10" src="images/spacer.gif" width="1" /></td>
                </tr>
                <tr>
                    <td align="middle">
                        <asp:button id="OKButton" onclick="OKButton_Click" runat="server" Width="60px" Text="OK"></asp:button>
                    </td>
                    <td align="middle">
                        <a href="javascript:CloseWindow()">
                        <asp:button id="CancelButton" onclick="CancelButton_Click" runat="server" Width="60px" Text="Cancel"></asp:button>
                        </a></td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
