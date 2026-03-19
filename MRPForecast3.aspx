<%@ Page Language="VB" %>

<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Math" %>
<script runat="server">

    Protected MRPNo As integer

        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        End Sub

        Sub cmdProceed_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                try
                    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
                    Dim RSSOByModel as SQLDataReader = ReqCOM.ExeDataReader("Select * from SO_FORECAST_M where SEL = 'YES'")
                    Dim RSPR as SQLDataReader
                    Dim CurrUP as decimal
                    Dim CurrVendor as string
                    Dim ETADate as Date
                    Dim sngLeak As Single

                    'Clear off temp table
                        ReqCOM.ExecuteNonQuery("Delete from BOM_Temp")
                    'Get Current MRP No
                        MRPNo = ReqCOM.GetFieldVal("Select MRP_FORECAST_NO from Main","MRP_FORECAST_NO")
                    'Register new MRP Explosion
                        ReqCOM.ExecuteNonQuery("Insert into MRP_FORECAST_M(MRP_NO,Create_by,Create_Date,STATUS) select " & MRPNo & ",'" & txtU_ID.text.toUpper() & "','" & now & "','OPEN';")

                    'Get Part's net qty (StoreBal = Open S/O + open P/O)
                        ReqCOM.ExecuteNonQuery("Update Part_Master set Net_Bal = Bal_Qty - Open_So + Open_Po")

                    'Processing Sales Order by Model
                        Do while RSSOByModel.read
                            GetBOMList(RSSOByModel("Lot_No"),RSSOByModel("Model_No"),RSSOByModel("Date_Temp"),RSSOByModel("Order_Qty"),RSSOByModel("Color_Desc"),RSSOByModel("Pack_Code"))
                        loop

                    'Update Lead Time for model
                        ReqCOM.ExecuteNonQuery("Update MAIN set MRP_FORECAST_No = MRP_FORECAST_No + 1")
                        RSSOByModel.close()
                        response.redirect("MRPForecast4.aspx?ID=" + MRPNo.TOSTRING)

            Catch err As Exception
                    Response.write(err.tostring)
            end try
            end if
        End Sub



                        Sub CalculateMRP(QtyReq as decimal)
                              TRY
                            Dim ReqCOM as ERp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
                            Dim RSBOMTemp as SQLDataReader = ReqCOM.ExeDataReader("Select * from BOM_Temp order by Seq_No asc")
                            Dim NetQtyReq as decimal = QtyReq
                            Dim StoreNetBal as decimal
                            Dim StrSql as string
                            NetQtyReq = NetQtyReq
                            Do while RSBOMTemp.read
                                if NetQtyReq <= 0 then exit Do
                                StoreNetBal = ReqCOM.GetFieldVal("Select Net_Bal from Part_Master where Part_No = '" & trim(RSBOMTemp("Part_No")) & "';","Net_Bal")
                                Select case StoreNetBal
                                    Case <= 0
                                        NetQtyReq = NetQtyReq
                                    case >= NetQtyReq
                                        StrSQL = "Insert into MRP_FORECAST_D(MODEL_NO,MRP_NO,LOT_NO,PART_NO,MAIN,QTY,ON_HOLD,Main_Part,SOURCE,P_Level,SO_TYPE) "
                                        StrSql = StrSql + "Select '" & trim(RSBOMTEmp("Model_No")) & "',"
                                        StrSql = StrSql + "" & MRPNo & ",'" & trim(RSBOMTEmp("Lot_No")) & "',"
                                        StrSql = StrSql + "'" & trim(RSBOMTEmp("Part_No")) & "',"
                                        StrSql = StrSql + "'" & trim(RSBOMTEmp("MAIN")) & "',"
                                        StrSql = StrSql + "" & NetQtyReq & "," & NetQtyReq & ","
                                        StrSql = StrSql + "'" & trim(RSBOMTEmp("MAIN_Part")) & "',"
                                        StrSql = StrSql + "'STORE','" & trim(RSBOMTEmp("P_Level")) & "','MODEL';"
                                        ReqCOM.ExecuteNonQuery(StrSQL)
                                        NetQtyReq = 0
                                        exit do
                                    case < NetQtyReq
                                      Dim QtyDed as decimal = iif((StoreNetBal > NetQtyReq),NetQtyReq,StoreNetBal)
                                        StrSQL = "Insert into MRP_FORECAST_D(MODEL_NO,MRP_NO,LOT_NO,PART_NO,MAIN,QTY,ON_HOLD,MAIN_PART,SOURCE,P_Level,SO_TYPE) "
                                        StrSql = StrSql + "Select '" & trim(RSBOMTEmp("Model_No")) & "',"
                                        StrSql = StrSql + "" & MRPNo & ",'" & trim(RSBOMTEmp("Lot_No")) & "',"
                                        StrSql = StrSql + "'" & trim(RSBOMTEmp("Part_No")) & "',"
                                        StrSql = StrSql + "'" & trim(RSBOMTEmp("MAIN")) & "',"
                                        StrSql = StrSql + "" & QtyDed & "," & QtyDed & ","
                                        StrSql = StrSql + "'" & trim(RSBOMTEmp("MAIN_Part")) & "',"
                                        StrSql = StrSql + "'STORE','" & trim(RSBOMTEmp("P_Level")) & "','MODEL';"
                                        ReqCOM.ExecuteNonQuery(StrSQL)
                                        NetQtyReq = NetQtyReq - QtyDed

                                end select
                                If NetQtyReq > 0 then
                                StrSQL = "Insert into MRP_FORECAST_D(MODEL_NO,MRP_NO,LOT_NO,PART_NO,MAIN,QTY,ON_HOLD,SOURCE,MAIN_PART,P_Level,SO_TYPE)"
                                StrSQL = StrSQl + "Select MODEL_NO," & MRPNo & ",LOT_NO,PART_NO,MAIN," & NetQtyReq & "," & NetQtyReq & ",'PR',MAIN_PART,P_Level,'MODEL' from BOM_Temp where MAIN = 'MAIN';"
                                ReqCOM.ExecuteNonQuery(StrSQL)



                            end if
                            loop

                RSBOMTemp.close()
                CATCH err As Exception
                END TRY
            end sub

            Sub GetBOMList(LotNo as string,ModelNo as string,BOMDate as date,OrderQty as decimal,Color as string,Packing as string)
                Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                Dim RevNo as decimal = ReqCOM.GetFieldVal("Select top 1 Revision from BOM_M where Model_no = '" & trim(ModelNo) & "' order by Effective_Date desc","Revision")
                Dim RSBomAlt as SQLDataReader = ReqCOM.ExeDataReader("Select * from BOM_D where Model_No = '" & trim(ModelNo) & "' and Revision = " & RevNo & ";")
                Dim strSql as string
                Dim QtyReq as decimal

                Do While RSBOMAlt.read
                    ReqCOM.ExecuteNonQuery ("Delete from BOM_TEMP")
                    ReqCOM.ExecuteNonQuery ("Insert into BOM_Temp(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & trim(LotNo) & "','" & trim(RSBOMALT("P_Level")) & "','" & trim(ModelNo) & "','" & trim(RSBOMALT("Part_No")) & "','" & trim(RSBOMALT("Part_No")) & "','MAIN','" & trim(RSBOMALT("P_Color")) & "','" & trim(RSBOMALT("Packing")) & "';")
                    ReqCOM.ExecuteNonQuery ("Insert into BOM_TEMP(LOT_NO,P_LEVEL,MODEL_NO,MAIN_PART,PART_NO,MAIN,P_Color,Packing) Select '" & trim(LotNo) & "','" & trim(RSBOMALT("P_Level")) & "','" & trim(ModelNo) & "',MAIN_PART,Part_No,'ALT','" & trim(RSBOMALT("P_Color")) & "','" & trim(RSBOMALT("Packing")) & "' from BOM_ALT where MAIN_PART = '" & trim(RSBOMALT("Part_No")) & "' and Model_No = '" & trim(ModelNo) & "';")
                    if Trim(color) = "-" then ReqCOM.ExecuteNonQuery ("Delete from BOM_TEMP where P_Color <> '-';")
                    If Trim(Color) <> "-" then ReqCOM.ExecuteNonQuery ("Delete from BOM_TEMP where P_Color <> '-' and P_Color <> '" & trim(Color) & "';")

                    if trim(Packing) = "-" then ReqCOM.ExecuteNonQuery ("Delete from BOM_TEMP where Packing <> '-';")
                    if trim(packing) <> "-" then ReqCOM.ExecuteNonQuery ("Delete from BOM_TEMP where Packing <> '-' and Packing <> '" & trim(Packing) & "';")

                    QtyReq = OrderQty * RSBOMAlt("P_Usage")
                    CalculateMRP (QtyReq)
                loop
                RSBomAlt.close()
            end sub

            Sub cmdPrevious_Click(sender As Object, e As EventArgs)
                response.redirect("MRPForecast1.aspx")
            End Sub

            Sub ServerValidate(sender As Object, e As ServerValidateEventArgs)
                Dim ReqcOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                If ReqcOM.FuncCheckDuplicate("Select U_ID from User_Profile where U_ID = '" & trim(txtU_ID.text) & "' and Pwd = '" & trim(txtPwd.text) & "';","U_ID") = false then
                    e.isvalid = false
                Else
                    e.isvalid = true
                End If
            End Sub

    Sub cmdCancel_Click(sender As Object, e As EventArgs)

    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" forecolor="" backcolor=" " width="100%" cssclass="FormDesc">Step
                                4 of 5 : Please provide user authentication before proceed.</asp:Label>
                            </p>
                            <p>
                            </p>
                            <p>
                                <table style="HEIGHT: 23px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" OnServerValidate="ServerValidate" ControlToValidate="txtU_ID" Display="Dynamic" ErrorMessage="Login Failed." EnableClientScript="False" ForeColor=" " CssClass="ErrorText"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="emailRequired" runat="server" Width="100%" ControlToValidate="txtU_ID" Display="dynamic" ErrorMessage="You don't seem to have supplied a valid User ID." EnableClientScript="False" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="passwordRequired" runat="server" Width="100%" ControlToValidate="txtPwd" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid password." EnableClientScript="False" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 52px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label1" runat="server" width="102px" cssclass="LabelNormal">User
                                                                    ID</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtU_ID" runat="server" Width="237px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;&nbsp;<asp:Label id="Label2" runat="server" width="102px" cssclass="LabelNormal">Password </asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtPwd" runat="server" Width="237px" textmode="Password"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 25px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdPrevious" onclick="cmdPrevious_Click" runat="server" Width="151px" Text="Previous" CausesValidation="False"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <p>
                                                                            <asp:Button id="cmdProceed" onclick="cmdProceed_Click" runat="server" Width="151px" Text="Proceed"></asp:Button>
                                                                        </p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="151px" Text="Cancel" CausesValidation="False"></asp:Button>
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
