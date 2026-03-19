<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub cmdUpdate_Click_1(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCom.ExecuteNonQuery("Update Part_Master set Buyer_Code = '" & trim(cmbBuyerCode.selecteditem.value) & "' where part_no like '" & trim(txtCommodity.text) & "%';")
            txtCommodity.text = ""
            ShowAlert("Buyer Code Updated.")
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdFinish_Click_1(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
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
    <form runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">PART
                                LIST REPORT</asp:Label>
                            </div>
                            <div align="center">
                            </div>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCommodity" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Commodity code." Width="100%"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="" cssclass="OutputText">Commodity</asp:Label></td>
                                                                <td widht="75%">
                                                                    <asp:TextBox id="txtCommodity" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" width="" cssclass="OutputText">Buyer Code</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbBuyerCode" runat="server" Width="100%" CssClass="OutputText">
                                                                        <asp:ListItem Value="Buyer 1">Buyer 1</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 2">Buyer 2</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 3">Buyer 3</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 4">Buyer 4</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 5">Buyer 5</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 6">Buyer 6</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 7">Buyer 7</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 8">Buyer 8</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 9">Buyer 9</asp:ListItem>
                                                                        <asp:ListItem Value="Buyer 10">Buyer 10</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="right">
                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click_1" runat="server" Width="120px" Text="Update"></asp:Button>
                                                    <asp:Button id="cmdFinish" onclick="cmdFinish_Click_1" runat="server" Width="120px" Text="Back"></asp:Button>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
