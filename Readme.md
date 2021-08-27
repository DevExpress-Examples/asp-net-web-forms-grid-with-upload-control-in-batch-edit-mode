<!-- default badges list -->
![](https://img.shields.io/endpoint?url=https://codecentral.devexpress.com/api/v1/VersionRange/128532872/16.2.6%2B)
[![](https://img.shields.io/badge/Open_in_DevExpress_Support_Center-FF7200?style=flat-square&logo=DevExpress&logoColor=white)](https://supportcenter.devexpress.com/ticket/details/T191652)
[![](https://img.shields.io/badge/📖_How_to_use_DevExpress_Examples-e9f6fc?style=flat-square)](https://docs.devexpress.com/GeneralInformation/403183)
<!-- default badges end -->
<!-- default file list -->
*Files to look at*:

* [Default.aspx](./CS/Default.aspx) (VB: [Default.aspx](./VB/Default.aspx))
* [Default.aspx.cs](./CS/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/Default.aspx.vb))
<!-- default file list end -->
# ASPxGridView - Batch Edit - How to use the upload control in Batch Edit mode
<!-- run online -->
**[[Run Online]](https://codecentral.devexpress.com/t191652/)**
<!-- run online end -->


This example is based on <a href="https://www.devexpress.com/Support/Center/p/T115096">T115096: ASPxGridView - Batch Editing - A simple implementation of an EditItem template</a> and illustrates how to use the upload control in Batch edit mode. Note that all files are <strong>stored in memory</strong> until you call the update method.<br /><br />1) Place ASPxUploadControl into the column's EditItem template:<br />


```aspx
<dx:GridViewDataTextColumn FieldName="FileName" Width="200">
    <EditItemTemplate>
        <dx:ASPxUploadControl ID="ASPxUploadControl1" runat="server" UploadMode="Advanced" Width="280px" ClientInstanceName="uc" FileUploadMode="OnPageLoad"
            OnFileUploadComplete="ASPxUploadControl1_FileUploadComplete">
            <ClientSideEvents TextChanged="OnTextChanged" FileUploadComplete="OnFileUploadComplete" />
        </dx:ASPxUploadControl>
    </EditItemTemplate>
</dx:GridViewDataTextColumn>

```


<br />2) Handle the grid's client-side <a href="https://help.devexpress.com/#AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridView_BatchEditStartEditingtopic">BatchEditStartEditing</a> event to set the grid's cell values to the upload control. It is possible to get the focused cell value using the <a href="https://help.devexpress.com/#AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridViewBatchEditStartEditingEventArgs_rowValuestopic">e.rowValues</a> property:<br />


```js
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
```


<br />3) Handle the grid's client-side <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientGridView_BatchEditConfirmShowingtopic">BatchEditConfirmShowing</a> event to prevent data loss on the upload control's callbacks:<br />


```js
function OnBatchConfirm(s, e) {
    e.cancel = browseClicked;
}

```


This "browseClicked" flag is set to true when the upload control starts uploading a file and to false when the file has been uploaded or the user starts editing another cell.<br /><br />4) Handle the upload control's client-side <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientUploadControl_TextChangedtopic">TextChanged</a> and <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientUploadControl_FileUploadCompletetopic">FileUploadComplete</a> events to automatically upload the selected file and update the cell value after:<br />


```js
function OnFileUploadComplete(s, e) {
    grid.batchEditApi.SetCellValue(hf.Get("visibleIndex"), "FileName", e.callbackData);
    grid.batchEditApi.EndEdit();
}
function OnTextChanged(s, e) {
    if (s.GetText()) {
        browseClicked = true;
        s.Upload();
    }
}
```


<br />5) Handle the upload control's server-side <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxUploadControl_FileUploadCompletetopic">FileUploadComplete</a> event to store the uploaded file in the session:<br />


```cs
protected void ASPxUploadControl1_FileUploadComplete(object sender, FileUploadCompleteEventArgs e) {
    var name = e.UploadedFile.FileName;
    e.CallbackData = name;

    if (Files.ContainsKey(hiddenField["visibleIndex"]))
        Files[hiddenField["visibleIndex"]] = e.UploadedFile.FileBytes;
    else
        Files.Add(hiddenField["visibleIndex"], e.UploadedFile.FileBytes);
}

```


<br />Now you can access all the uploaded files in the <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxGridView_BatchUpdatetopic">BatchUpdate</a> event handler. Clear the session storage after you have updated the files.<br /><br /><strong>See also:</strong><br /><a href="https://www.devexpress.com/Support/Center/p/T191714">T191714: GridView - Batch Edit - How to use the upload control in Batch Edit mode</a>

<br/>


