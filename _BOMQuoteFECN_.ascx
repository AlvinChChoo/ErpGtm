<%@ Control Language="VB" Debug="true" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    sub LoadFECNDet()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim strSql as string
    
    
        strsql ="select * from fecn_d where fecn_no in (select fecn_no from fecn_m where model_no = '" & trim(Request.params("ModelNo")) & "' and fecn_status = 'PENDING APPROVAL')"
    
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=550,height=300');")
        Script.Append("</script" & ">")
        page.RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        LoadFECNDet
        FormatRow
    End Sub
    
    Sub FormatRow()
        Dim PartDet as string
        Dim i As Integer
        Dim ETADate,MinOrderQty,StdPackQty,UP,QtyToBuy,ReqQty,Diff,Amt,RowNo As Label
        Dim PartSpecB4,MPartNoB4,PUsageB4,PLevelB4,PLocationB4,MAINPARTB4,RefAltPartB4 As Label
        Dim PartSpec,MPartNo,PUsage,PLevel,PLocation,MAINPART,RefAltPart As Label
        Dim PartDescB4,PartDesc As Textbox
    
    
        For i = 0 To MyList.Items.Count - 1
            PartDescB4 = CType(MyList.Items(i).FindControl("PartDescB4"), Textbox)
            PartSpecB4 = CType(MyList.Items(i).FindControl("PartSpecB4"), Label)
            MPartNoB4 = CType(MyList.Items(i).FindControl("MPartNoB4"), Label)
            MainPartB4 = CType(MyList.Items(i).FindControl("MainPartB4"), Label)
            PLocationB4 = CType(MyList.Items(i).FindControl("PLocationB4"), Label)
            PUsageB4 = CType(MyList.Items(i).FindControl("PUsageB4"), Label)
            PLevelB4 = CType(MyList.Items(i).FindControl("PLevelB4"), Label)
            RefAltPartB4 = CType(MyList.Items(i).FindControl("RefAltPartB4"), Label)
            PartDesc = CType(MyList.Items(i).FindControl("PartDesc"), Textbox)
            PartSpec = CType(MyList.Items(i).FindControl("PartSpec"), Label)
            MPartNo = CType(MyList.Items(i).FindControl("MPartNo"), Label)
            MainPart = CType(MyList.Items(i).FindControl("MainPart"), Label)
            PLocation = CType(MyList.Items(i).FindControl("PLocation"), Label)
            PUsage = CType(MyList.Items(i).FindControl("PUsage"), Label)
            PLevel = CType(MyList.Items(i).FindControl("PLevel"), Label)
            RefAltPart = CType(MyList.Items(i).FindControl("RefAltPart"), Label)
    
            if trim(MPartNo.text) = "<NULL>" then MPartNo.text = "-"
            if trim(MPartNoB4.text) = "<NULL>" then MPartNoB4.text = "-"
    
            if trim(MainPartB4.text) = "-" then PartDescB4.text = "N/A"
            if trim(MainPartB4.text) <> "-" then PartDescB4.text = "Part #           : " & trim(MainPartB4.text) & vblf & "DESC/SPEC    : " & trim(PartDescB4.text) & " /(" & trim(PartSpecB4.text) & ")" & vblf & "MPN              : " & trim(MPartNoB4.text) & vblf & "Usage/Level  : " & cdec(PUsageB4.text) & " (" & trim(PLevelB4.text) & ")" & vblf & "Location        : " & trim(PLocationB4.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPartB4.text)
    
            if trim(MainPart.text) = "-" then PartDesc.text = "N/A"
            if trim(MainPart.text) <> "-" then PartDesc.text = "Part #           : " & trim(MainPart.text) & vblf & "DESC/SPEC    : " & trim(PartDesc.text) & " /(" & trim(PartSpec.text) & ")" & vblf & "MPN              : " & trim(MPartNo.text) & vblf & "Usage/Level  : " & cdec(PUsage.text) & " (" & trim(PLevel.text) & ")" & vblf & "Location        : " & trim(PLocation.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPart.text)
    
            RowNo = CType(MyList.Items(i).FindControl("RowNo"), Label)
            RowNo.text = i + 1
        Next
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
    
    End Sub

</script>
<p align="center">
    <asp:Label id="Label2" runat="server" width="100%" cssclass="SectionHeader">FECN ITEMS</asp:Label> 
    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
        <tbody>
            <tr>
                <td>
                    <p>
                        <asp:DataList id="MyList" runat="server" Width="100%" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Height="101px" OnSelectedIndexChanged="MyList_SelectedIndexChanged" Font-Size="XX-Small" Font-Names="Arial">
                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                            <ItemStyle font-size="XX-Small"></ItemStyle>
                            <ItemTemplate>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label id="RowNo" visible="true" runat="server" text='11' cssclass="ErrorText" /> <span class="ListLabel">FECN
                                                # : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Fecn_No") %> </span> 
                                            </td>
                                            <td>
                                                <span class="ListLabel">Type Of Changes : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Type_CHANGE") %> </span> 
                                            </td>
                                            <td>
                                                <span class="ListLabel">Implementation : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Imp_Type") %> </span> 
                                            </td>
                                            <td>
                                                <span class="ListLabel">Implementation Qty : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Imp_Qty") %> </span> 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <span class="ListLabel">Reason of change : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "REASON_CHANGE") %> </span> <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tr>
                                        <td valign="top">
                                            <span class="OutputText">Before </span> 
                                        </td>
                                        <td>
                                            <asp:textbox id="PartDescB4" CssClass="ListOutput" runat="server" width= "700px" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC_B4") %>'></asp:textbox>
                                            <asp:Label id="MAINPARTB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART_B4") %>'></asp:Label> <asp:Label id="PUSAGEB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE_B4") %>'></asp:Label> <asp:Label id="PLOCATIONB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION_B4") %>'></asp:Label> <asp:Label id="PartSpecB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC_B4") %>'></asp:Label> <asp:Label id="PLEVELB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL_B4") %>'></asp:Label> <asp:Label id="MPARTNOB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO_B4") %>'></asp:Label> <asp:Label id="RefAltPartB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt_B4") %>'></asp:Label> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <span class="OutputText">After</span> 
                                        </td>
                                        <td>
                                            <asp:textbox id="PartDesc" CssClass="ListOutput" runat="server" width= "700px" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC") %>'></asp:textbox>
                                            <asp:Label id="MAINPART" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART") %>'></asp:Label> <asp:Label id="PUSAGE" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE") %>'></asp:Label> <asp:Label id="PLOCATION" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION") %>'></asp:Label> <asp:Label id="PartSpec" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC") %>'></asp:Label> <asp:Label id="PLEVEL" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL") %>'></asp:Label> <asp:Label id="MPARTNO" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO") %>'></asp:Label> <asp:Label id="RefAltPart" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt") %>'></asp:Label> 
                                        </td>
                                    </tr>
                                </table>
                                <br />
                            </ItemTemplate>
                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                        </asp:DataList>
                    </p>
                </td>
            </tr>
        </tbody>
    </table>
</p>