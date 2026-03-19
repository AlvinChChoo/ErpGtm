<%@ Page Language="VB" Debug="true" %>
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
        if page.isPostBack = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
    
            if request.cookies("U_ID") is nothing then response.redirect("SignIn.aspx")
    
            if ReqCOM.FuncCheckDuplicate("Select Buyer_Code from Buyer where U_ID='" & trim(request.cookies("U_ID").value) & "';","Buyer_Code") = true then
                If SortField = "" then SortField = "PR.Part_No"
                'lblPRNo.text = ReqCOM.GetFieldVal("Select PR_NO from tpr_M where Seq_No = " & request.params("ID") & ";","PR_NO")
                lblBuyerCode.text = ReqCOM.GetFieldVal("Select Buyer_Code from Buyer where U_ID='" & trim(request.cookies("U_ID").value) & "';","Buyer_Code")
                'lblBuyerName.text = Request.cookies("U_ID").value
                LoadBuyerApprovedParts()
            Else
                response.redirect("UnauthorisedUser.aspx")
            End if
        end if
    End Sub
    
    Sub LoadBuyerApprovedParts()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        'Dim StrSql as string = "SELECT PM.Part_Desc,PM.Buyer_Code,PR.Approved,BUYER_PROCESS,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM tpr_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.pr_date is not null and PR.Buyer_Approval = 'Y' and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by " & SortField & " " & SortSeq
        Dim StrSql as string = "SELECT PM.Part_Desc,PM.Buyer_Code,PR.Approved,BUYER_PROCESS,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM tpr_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.pr_date is not null and PR.Buyer_Approval = 'Y' and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by " & SortField & " " & SortSeq
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgBuyerApprovedParts.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgBuyerApprovedParts.DataBind()
    end sub
    
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
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Protected Sub FormatBuyer(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(7).Text = cint(E.Item.Cells(7).Text)
            E.Item.Cells(8).Text = format(cdec(E.Item.Cells(8).Text),"##,##0.0000")
            E.Item.Cells(10).Text = format(E.Item.Cells(8).Text * E.Item.Cells(7).Text,"##,##0.00")
            Dim BuyerApproval as Label = CType(e.Item.FindControl("BuyerApproval"), Label)
    
            Dim QtyToBuy as label = CType(e.Item.FindControl("QtyToBuy"), label)
            E.Item.Cells(9).Text = format(E.Item.Cells(8).Text * QtyToBuy.Text,"##,##0.00")
        End if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithoutSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    
    Sub dtgBuyerApprovedParts_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("TempPR.aspx")
    End Sub
    
    Sub LinkButton2_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRWithoutSource.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub LinkButton3_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRApprovedParts.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub LinkButton4_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRPendingApproval.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgBuyerApprovedParts.CurrentPageIndex = e.NewPageIndex
        LoadBuyerApprovedParts()
    end sub

</script>
<! Customer.aspx ><html>
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
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">TEMPORARY PURCHASE
                                REQUISITION - APPROVED PARTS</asp:Label> 
                                <table style="HEIGHT: 16px" bordercolor="gray" cellspacing="0" cellpadding="0" width="100%" bgcolor="silver" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton2" onmouseover="popup('Show all the parts without supplier. Buyer need to find supplier before approval','yellow')" onclick="LinkButton2_Click" onmouseout="kill()" runat="server" Width="100%" Font-Bold="True" CausesValidation="False" ForeColor="White">PARTS WITHOUT SOURCE</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="34%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton3" onmouseover="popup('Parts that have been approved by buyer.','yellow')" onclick="LinkButton3_Click" onmouseout="kill()" runat="server" Width="100%" Font-Bold="True" CausesValidation="False" ForeColor="White" BackColor="#FF8080">PARTS APPROVED</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton4" onmouseover="popup('Parts that are pending for buyer approval.','yellow')" onclick="LinkButton4_Click" onmouseout="kill()" runat="server" Width="100%" Font-Bold="True" CausesValidation="False" ForeColor="White">PENDING PART APPROVAL</asp:LinkButton>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgBuyerApprovedParts" runat="server" width="100%" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" AllowSorting="True" OnItemDataBound="FormatBuyer" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgBuyerApprovedParts_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_Desc" SortExpression="PR.Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="REQ_DATE" HeaderText="REQ DATE" DataFormatString="{0:d}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PR_DATE" HeaderText="PR DATE" DataFormatString="{0:d}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PR_QTY" HeaderText="PR QTY" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="QTY TO BUY(a)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyToBuy" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="VARIANCE" HeaderText="VAR(Qty)(b)" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P(c)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Amt(a*c)" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Var(Amt)(b*c)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblBuyerCode" runat="server" cssclass="OutputText" visible="False"></asp:Label>
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="127px" Text="Back"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
