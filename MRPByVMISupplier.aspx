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
            dissql ("Select ven_Code, ven_code + ' - ' + Ven_Name as [Ven_Name] from Vendor where ven_Code in (select distinct(Ven_Code) from part_source where item_class <> '' or buffer_qty is not null or buffer_wks is not null or liability_qty is not null or liability_wks is not null)","Ven_Code","Ven_Name",cmbVenCode)
        End if
    End Sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("TRUNCATE TABLE mrp_vmi")
        ReqCOM.ExecuteNonQuery("insert into mrp_vmi(part_no,lot_no,shortage_qty,ETA_DATE) select part_no,lot_no,net_req_qty,ETA_DATE from mrp_d_gross where part_no in (select Part_No from part_source where (item_class <> '' or buffer_qty is not null or buffer_wks is not null or liability_qty is not null or liability_wks is not null) and ven_code = '" & trim(cmbVenCode.selecteditem.value) & "')")
        ReqCOM.ExecuteNonQuery("update mrp_vmi set work_week = datepart(ww,eta_date)")
        ReqCOM.ExecuteNonQuery("update mrp_vmi set week_day = datepart(dw,eta_date)")
        ReqCOM.ExecuteNonQuery("Update mrp_vmi set first_date_of_week = eta_date - week_day + 1")
        ReqCOM.ExecuteNonQuery("uPDATE mrp_vmi SET WORK_WEEK_REM = 'WEEK ' + CAST(WORK_WEEK AS NVARCHAR(20))")
        ReqCOM.ExecuteNonQuery("update MRP_VMI set row_ind = CONVERT(char(6), first_date_of_week,12) + LOT_NO")
        ReqCOM.ExecuteNonQuery("UPDATE MRP_VMI SET MRP_VMI.OPEN_PO = CONVERT(DECIMAL(10,0),PART_MASTER.OPEN_PO),MRP_VMI.PART_DESC = PART_MASTER.PART_DESC,MRP_VMI.PART_SPEC = PART_MASTER.PART_SPEC,MRP_VMI.M_PART_NO = PART_MASTER.M_PART_NO,MRP_VMI.MFG = PART_MASTER.MFG FROM MRP_VMI,PART_MASTER WHERE MRP_VMI.PART_NO = PART_MASTER.PART_NO")
    
        ReqCOM.ExecuteNonQUery("Create Table Part_Source_Temp (Part_No nvarchar(20),MOQ numeric,SPQ numeric)")
        ReqCOm.ExecuteNonQUery("Insert into Part_Source_Temp(Part_No,MOQ) select distinct(Part_No),Max(Min_Order_Qty) from part_Source group by part_no")
        ReqCOM.ExecuteNonQuery("Update Part_Source_Temp set part_source_Temp.spq=Part_Source.std_pack_Qty from part_source_Temp,Part_Source where part_source_Temp.part_no=Part_Source.part_no and part_source_Temp.moq=Part_Source.min_order_qty")
        ReqCOM.ExecuteNonQuery("UPDATE MRP_VMI SET MRP_VMI.MOQ = CONVERT(DECIMAL(10,0),Part_Source_Temp.MOQ),MRP_VMI.SPQ=CONVERT(DECIMAL(10,0),Part_Source_Temp.SPQ) FROM MRP_VMI,Part_Source_Temp WHERE MRP_VMI.PART_NO = Part_Source_Temp.PART_NO")
        ReqCOM.ExecuteNonQUery("drop table Part_Source_Temp")
    
        ReqCOM.ExecuteNonQuery("INSERT INTO MRP_VMI(PART_NO,PART_DESC,PART_SPEC,MFG,M_PART_NO,OPEN_PO,ROW_SEQ,MOQ,SPQ,first_date_of_week,work_week_rem,work_week,Cust_Part_No,past_due) SELECT top 1 'G-Tek Part No.','Description','PART SPEC','Manufacturer','MPN','Open Order',1,'MOQ','SPQ',first_date_of_week,work_week_rem,work_week,'End Customer Part No.','Past Due' from mrp_vmi order by first_date_of_week asc")
        ShowReport("PopupReportviewer.aspx?RptName=MRPVMI&Vendor=" & trim(cmbVenCode.selecteditem.value))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MRP
                                By VMI Supplier</asp:Label>
                            </div>
                            <p>
                                <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server">Supplier Code / Name</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbVenCode" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="120px" Text="View Report"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" Width="120px" Text="Back"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <asp:TextBox id="TextBox1" runat="server" Width="488px" Visible="False">select item_class,buffer_qty,buffer_wks,liability_qty from part_source where ven_code = 'TC029' and item_class is not null or buffer_qty is not null or buffer_wks is not null or liability_qty is not null or liability_wks is not null</asp:TextBox>
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
