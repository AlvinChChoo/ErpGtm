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
        IF page.ispostback=false then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
    
            Do while RsUPASM.read
                lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                lblAppBy.text = trim(Request.cookies("U_ID").value)
                'txtRem.text = RsUPASM("REM").tostring
                'lblCreateBy.text = RsUPASM("CREATE_BY").tostring
                'lblCreateDate.text = RsUPASM("CREATE_DATE").tostring
            loop
            RsUPASM.Close
            LoadData
        end if
    End Sub
    
    sub LoadData
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet("Select * from UPAS_D where UPAS_NO = '" & trim(lblUPASNo.text) & "';","UPAS_D")
        DataGrid1.DataSource=resExePagedDataSet.Tables("UPAS_D").DefaultView
        DataGrid1.DataBind()
    End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("UPAEntryDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdYes_Click(sender As Object, e As EventArgs)
        Dim ReqCOM AS erp_gtm.erp_gtm = NEW erp_gtm.erp_gtm
        Dim StrSql as string
        Dim RsUPA as SQLDataReader = ReqCOM.ExeDataReader("Select * from UPAS_D where UPAS_NO = '" & trim(lblUPASNo.text) & "';")
    
        Do while RsUPA.read
    
            Select case RsUPA("Act")
                Case "ADD"
                    StrSql =  "Insert into Part_Source(PART_NO,VEN_CODE,LEAD_TIME,UP_APP_NO,UP_APP_DATE,STD_PACK_QTY,MIN_ORDER_QTY,UP,CREATE_BY,CREATE_DATE,VEN_SEQ,APP_BY) "
                    StrSql = StrSql + "Select UD.PART_NO,UD.A_VEN_CODE,UD.LEAD_TIME,UD.UPAS_NO,UM.MGT_Date,UD.STD_PACK,UD.MIN_ORDER_QTY,UD.UP,'" & trim(request.cookies("U_ID").value) & "','" & now & "',0.9,UM.Mgt_By from upas_m UM, UPAS_D UD where UD.UPAS_NO = UM.Upas_No and UD.Seq_No = " & rsUPA("Seq_No") & ";"
                    ReqCOM.ExeDataReader(StrSql)
                Case "DELETE"
                    StrSql = "Delete from Part_Source where Ven_Code = '" & trim(rsUPA("ven_Code")) & "' and Part_No = '" & trim(rsUPA("Part_No")) & "';"
                    ReqCOM.ExeDataReader(StrSql)
                Case "EDIT"
                    StrSql = "Update Part_Source set UP_APP_NO = '" & trim(rsUPA("UPAS_NO")) & "',PART_NO = '" & trim(rsUPA("Part_No")) & "',Ven_Code='" & trim(rsUPA("A_VEN_CODE")) & "',UP = " & trim(rsUPA("A_UP")) & ", LEAD_TIME=" & rsUPA("A_LEAD_TIME") & ",STD_PACK_Qty=" & rsUPA("A_STD_PACK") & " ,MIN_ORDER_QTY=" & rsUPA("A_MIN_ORDER_QTY") & " where Ven_Code = '" & trim(rsUPA("Ven_Code")) & "' and part_no = '" & trim(rsUPA("Part_No")) & "'"
                    ReqCOM.ExeDataReader(StrSql)
            End select
        loop
        StrSql = "Update UPAS_M set Entry_By = '" & request.cookies("U_ID").value & "',Entry_Date = '" & now & "' where upas_No = '" & trim(lblUPASNo.text) & "'"
        ReqCOM.ExeDataReader(StrSql)
        Response.redirect("UPAEntryCon.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label5" runat="server" cssclass="FormDesc" width="100%">UNIT PRICE
                                APPROVAL SHEET UPDATE</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 53px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="128px">Approval
                                                                    Sheet No</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" cssclass="OutputText" width="480px"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="128px">Approved
                                                                    By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblAppBy" runat="server" cssclass="OutputText" width="356px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="128px">Reason
                                                                    for approval</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtReason" runat="server" Height="60px" TextMode="MultiLine" Width="348px" CssClass="OutputText"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="DataGrid1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowPaging="false" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="false" AutoGenerateColumns="False" Font-Name="Verdana">
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="ACT" HeaderText="Action"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="VEN_CODE" HeaderText="Supplier(C)"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="A_VEN_CODE" HeaderText="Supplier(N)"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P(C)" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="A_UP" HeaderText="U/P(N)" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="DIFF_AMT" HeaderText="Diff(amt)" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="DIFF_PCTG" HeaderText="Diff(%)" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="LEAD_TIME" HeaderText="L/T(C)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="A_LEAD_TIME" HeaderText="L/T(N)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="STD_PACK" HeaderText="SPQ(C)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="A_STD_PACK" HeaderText="SPQ(N)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MIN_ORDER_QTY" HeaderText="MOQ(C)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="A_MIN_ORDER_QTY" HeaderText="MOQ(N)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label2" runat="server" cssclass="Instruction">Are you sure to update
                                                    this Approval Sheet ?</asp:Label>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 21px" width="100%" align="right">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdYes" onclick="cmdYes_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="53px" Text="No"></asp:Button>
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
