<%@ Page Language="VB" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.isPostBack = false then
                Dissql ("Select Lot_No from SO_PART_M order by SO_Date asc","Lot_No","Lot_No",cmbSONo)
    
            End if
        End Sub
    
        Sub Button1_Click(sender As Object, e As EventArgs)
            Response.redirect("ReportViewer.aspx?RptName=SalesOrderPart&LotNo=" & cmbSONo.selecteditem.value & "&ReturnURL=SalesOrderPartRpt.aspx")
        End Sub
    
    
    
         SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = trim(FValue)
                .DataTextField = trim(FText)
                .DataBind()
             end with
             ResExeDataReader.close()
        End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub LinkButton3_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderModelRpt.aspx")
    End Sub
    
    Sub LinkButton4_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderPartRpt.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <div id="dek">
    </div>
    <script type="text/javascript">

    Xoffset=-60;
    Yoffset= 20;
    var old,skn,iex=(document.all),yyy=-1000;
    var ns4=document.layers
    var ns6=document.getElementById&&!document.all
    var ie4=document.all

    if (ns4)
        skn=document.dek
    else if (ns6)
        skn=document.getElementById("dek").style
    else if (ie4)
        skn=document.all.dek.style

    if(ns4)document.captureEvents(Event.MOUSEMOVE);
    else
    {
        skn.visibility="visible"
        skn.display="none"
    }
    document.onmousemove=get_mouse;

    function popup(msg,bak)
    {
        var content="<TABLE  WIDTH=150 BORDER=1 BORDERCOLOR=black CELLPADDING=2 CELLSPACING=0 "+
        "BGCOLOR="+bak+"><TD ALIGN=center><FONT COLOR=black SIZE=2>"+msg+"</FONT></TD></TABLE>";
        yyy=Yoffset;
        if(ns4){skn.document.write(content);skn.document.close();skn.visibility="visible"}
        if(ns6){document.getElementById("dek").innerHTML=content;skn.display=''}
        if(ie4){document.all("dek").innerHTML=content;skn.display=''}
    }

    function get_mouse(e)
    {
        var x=(ns4||ns6)?e.pageX:event.x+document.body.scrollLeft;
        skn.left=x+Xoffset;
        var y=(ns4||ns6)?e.pageY:event.y+document.body.scrollTop;
        skn.top=y+yyy;
    }

    function kill()
    {
        yyy=-1000;
        if(ns4){skn.visibility="hidden";}
        else if (ns6||ie4)
        skn.display="none"
    }
</script>
    <form method="post" runat="server">
        <font face="Verdana" size="4"> 
        <p>
            <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SALES
                                ORDER (SALES BY PARTS)</asp:Label>
                            </div>
                            <table style="HEIGHT: 16px" bordercolor="gray" cellspacing="0" cellpadding="0" width="100%" bgcolor="silver" border="1">
                                <tbody>
                                    <tr>
                                        <td width="50%">
                                            <p align="center">
                                                <asp:LinkButton id="LinkButton3" onmouseover="popup('View Sales Order (Sales of Model)','yellow')" onclick="LinkButton3_Click" onmouseout="kill()" runat="server" Width="100%" Font-Bold="True" CausesValidation="False" ForeColor="White">SALES ORDER (MODEL)</asp:LinkButton>
                                            </p>
                                        </td>
                                        <td width="50%">
                                            <p align="center">
                                                <asp:LinkButton id="LinkButton4" onmouseover="popup('View Sales Order (Sales of Part)','yellow')" onclick="LinkButton4_Click" onmouseout="kill()" runat="server" Width="100%" BackColor="#FF8080" Font-Bold="True" CausesValidation="False" ForeColor="White">SALES ORDER (PARTS)</asp:LinkButton>
                                            </p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <p align="center">
                                <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="50%" align="center">
                                    <tbody>
                                        <tr>
                                            <td width="84%" border="0">
                                                <table style="HEIGHT: 10px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="LotNo" runat="server" cssclass="LabelNormal" width="112px">Lot No : </asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbSONo" runat="server" Width="233px"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 17px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="Button2" onclick="Button1_Click" runat="server" Width="117px" Text="View Report"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="117px" Text="Back"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        </font><font face="Verdana" size="4"></font>
    </form>
</body>
</html>
