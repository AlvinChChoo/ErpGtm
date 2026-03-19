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

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
            If SortField = "" then SortField = "PM.Part_No"
            Dissql("Select DISTINCT(LOT_NO) as [lot_no] from MRP_D_rpt order by LOT_NO ASC","LOT_NO","LOT_NO",cmbLOTNO)
            if cmbLOTNO.selectedindex = 0 then procLoadGridData
        End if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "SELECT sum(PR.QTY) as [QTY],PR.PART_NO,PR.Lot_No,PR.Model_No,PM.PART_DESC + '|' + PM.PART_SPEC AS [PART_DESC] FROM MRP_D_rpt PR,PART_MASTER PM WHERE PR.lot_no = '" & TRIM(cmbLotNo.selecteditem.value) & "' AND PR.PART_NO = PM.PART_NO and " & trim(cmbBy.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' group by PR.PART_NO,PR.Lot_No,PR.Model_No,PM.Part_Desc,PM.Part_Spec,PM.Part_No"
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim SortSeq as String
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql & " Order by " & SortField & " " & SortSeq,"MRP_D")
        dtgShortage.DataSource=resExePagedDataSet.Tables("MRP_D").DefaultView
        dtgShortage.DataBind()
    end sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
                 Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                 Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
                 with obj
                     .items.clear
                     .DataSource = ResExeDataReader
                     .DataValueField = FValue
                     .DataTextField = FText
                     .DataBind()
                 end with
                 ResExeDataReader.close()
    
             End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgShortage.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Property PartWithoutSource() As integer
        Get
            Dim o As Object = ViewState("PartWithoutSource")
    
            If o Is Nothing Then
                Return 0
            End If
            Return cint(o)
        End Get
        Set(ByVal Value As integer)
            ViewState("PartWithoutSource") = Value
        End Set
    End Property
    
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            e.item.cells(3).text = format(cint(e.item.cells(3).text),"##,##0")
        End if
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    
    End Sub
    
    
    
    Property SortField() As String
             Get
                 Dim o As Object = ViewState("SortField")
                 If o Is Nothing Then
                     Return [String].Empty
                 End If
                 Return CStr(o)
             End Get
             Set(ByVal Value As String)
                 If Value = SortField Then
                     SortAscending = Not SortAscending
                 End If
                 ViewState("SortField") = Value
             End Set
         End Property
    
         Property SortAscending() As Boolean
             Get
                 Dim o As Object = ViewState("SortAscending")
    
                 If o Is Nothing Then
                     Return True
                 End If
                 Return CBool(o)
             End Get
             Set(ByVal Value As Boolean)
                 ViewState("SortAscending") = Value
             End Set
         End Property
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        procLoadGridData
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        procLoadGridData
    End Sub
    
    Sub LinkButton2_Click(sender As Object, e As EventArgs)
        Response.redirect("MRPByLot.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        response.redirect("MRPAll.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub LinkButton3_Click(sender As Object, e As EventArgs)
        response.redirect("MRPByPart.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub LinkButton4_Click(sender As Object, e As EventArgs)
        response.redirect("MRPByModel.aspx?ID=" & Request.params("ID"))
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">Material
                                Shortage List - View By Lot No</asp:Label> 
                                <table style="HEIGHT: 16px" bordercolor="gray" cellspacing="0" cellpadding="0" width="100%" bgcolor="silver" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton1" onmouseover="popup('View shortage list by Part No.','yellow')" onclick="LinkButton1_Click" onmouseout="kill()" runat="server" Font-Bold="True" ForeColor="White" CausesValidation="False" Width="100%">VIEW BY PART NO</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="34%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton2" onmouseover="popup('View shortage list by Lot No','yellow')" onclick="LinkButton2_Click" onmouseout="kill()" runat="server" Font-Bold="True" ForeColor="White" CausesValidation="False" Width="100%" BackColor="#FF8080">VIEW BY LOT NO</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton4" onmouseover="popup('View shortage list by Model','yellow')" onclick="LinkButton4_Click" onmouseout="kill()" runat="server" Font-Bold="True" ForeColor="White" CausesValidation="False" Width="100%">VIEW BY MODEL</asp:LinkButton>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <p>
                                <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 12px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText" width="">LOT NO</asp:Label>&nbsp;&nbsp; 
                                                                        <asp:DropDownList id="cmbLotNo" runat="server" Width="207px" CssClass="OutputText"></asp:DropDownList>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText" width="">SEARCH</asp:Label>&nbsp;<asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGO)" onclick="GetFocus(txtSearch)" runat="server" Width="112px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText" width="">BY</asp:Label>&nbsp;<asp:DropDownList id="cmbBy" runat="server" Width="114px" CssClass="OutputText">
                                                                            <asp:ListItem Value="PR.PART_NO">PART NO</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp; 
                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="35px" Text="GO"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" PagerStyle-HorizontalAligh="Right" AllowPaging="True" OnPageIndexChanged="OurPager" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" AllowSorting="True" OnSortCommand="SortGrid" Height="35px" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="PART_NO" SortExpression="PM.PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MODEL_NO" SortExpression="MODEL_NO" HeaderText="MODEL NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_DESC" HeaderText="DESCRIPTION/SPEC"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="QTY" HeaderText="QTY" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" Width="157px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
