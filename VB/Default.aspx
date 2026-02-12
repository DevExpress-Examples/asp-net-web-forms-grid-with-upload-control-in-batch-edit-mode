<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v16.2, Version=16.2.17.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>




<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        var browseClicked = false;

        //upload control
        function OnFileUploadComplete(s, e) {
            grid.batchEditApi.EndEdit();
            grid.batchEditApi.SetCellValue(hf.Get("visibleIndex"), "FileName", e.callbackData);

        }
        function OnTextChanged(s, e) {
            if (s.GetText()) {
                browseClicked = true;
                s.Upload();
            }
        }
        function SetUCText(text) {
            var inputs = uc.GetMainElement().getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                var input = inputs[i];
                if (!isHidden(input) && input.attributes["type"].value == "text") {
                    inputs[i].value = text;
                    return;
                }
            }
        }


        //grid
        function OnBatchStartEditing(s, e) {
            browseClicked = false;
            hf.Set("visibleIndex", e.visibleIndex);
            var fileNameColumn = s.GetColumnByField("FileName");
            if (!e.rowValues.hasOwnProperty(fileNameColumn.index))
                return;
            var cellInfo = e.rowValues[fileNameColumn.index];

            setTimeout(function () {
                SetUCText(cellInfo.value);
            }, 0);            
        }
        function OnBatchEditEndEditing(s, e) {
            browseClicked = false;
            SetUCText("");
        }
        function OnBatchConfirm(s, e) {
            e.cancel = browseClicked;
        }


        function isHidden(el) {
            return (el.offsetParent === null)
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxHiddenField ID="hiddenField" runat="server" ClientInstanceName="hf"></dx:ASPxHiddenField>
            <dx:ASPxGridView ID="ASPxGridView1" runat="server" KeyFieldName="ID" ClientInstanceName="grid"
                OnBeforeGetCallbackResult="ASPxGridView1_BeforeGetCallbackResult"
                OnBatchUpdate="ASPxGridView1_BatchUpdate"
                OnCustomErrorText="ASPxGridView1_CustomErrorText">
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="ID" ReadOnly="true"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PersonName">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="FileName" Width="200">
                        <EditItemTemplate>
                            <dx:ASPxUploadControl ID="ASPxUploadControl1" runat="server" UploadMode="Advanced" Width="280px" ClientInstanceName="uc" FileUploadMode="OnPageLoad"
                                OnFileUploadComplete="ASPxUploadControl1_FileUploadComplete">
                                <ClientSideEvents TextChanged="OnTextChanged" FileUploadComplete="OnFileUploadComplete" />
                            </dx:ASPxUploadControl>
                        </EditItemTemplate>
                    </dx:GridViewDataTextColumn>
                </Columns>
                <SettingsEditing Mode="Batch"></SettingsEditing>
                <ClientSideEvents BatchEditStartEditing="OnBatchStartEditing" BatchEditConfirmShowing="OnBatchConfirm" BatchEditEndEditing="OnBatchEditEndEditing" />
            </dx:ASPxGridView>
        </div>
    </form>
</body>
</html>