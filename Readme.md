<!-- default badges list -->
![](https://img.shields.io/endpoint?url=https://codecentral.devexpress.com/api/v1/VersionRange/128532872/16.2.6%2B)
[![](https://img.shields.io/badge/Open_in_DevExpress_Support_Center-FF7200?style=flat-square&logo=DevExpress&logoColor=white)](https://supportcenter.devexpress.com/ticket/details/T191652)
[![](https://img.shields.io/badge/📖_How_to_use_DevExpress_Examples-e9f6fc?style=flat-square)](https://docs.devexpress.com/GeneralInformation/403183)
<!-- default badges end -->

# GridView for ASP.NET Web Forms - How to use the upload control in batch edit mode
<!-- run online -->
**[[Run Online]](https://codecentral.devexpress.com/t191652/)**
<!-- run online end -->

This example illustrates how to use the upload control in batch edit mode. Note that all files are stored in memory until you call the update method.


## Implementation Details

1. Place an upload control to a column's edit item template:

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

2. Handle the grid's client-side [BatchEditStartEditing](https://docs.devexpress.com/AspNet/js-ASPxClientGridView.BatchEditStartEditing) event to set the grid's cell values to the upload control. Use the [rowValues](https://docs.devexpress.com/AspNet/js-ASPxClientGridViewBatchEditStartEditingEventArgs.rowValues) argument property to get the focused cell value:

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

3. Handle the grid's client-side [BatchEditConfirmShowing](https://docs.devexpress.com/AspNet/js-ASPxClientGridView.BatchEditConfirmShowing) event to prevent data loss on the upload control's callbacks:

    ```js
    function OnBatchConfirm(s, e) {
        e.cancel = browseClicked;
    }
    ```
    
    This `browseClicked` flag is set to `true` when the upload control starts uploading a file and to `false` when the file has been uploaded or a user starts editing another cell.


4. Handle the upload control's client-side [TextChanged](https://docs.devexpress.com/AspNet/js-ASPxClientUploadControl.TextChanged) and [FileUploadComplete](https://docs.devexpress.com/AspNet/js-ASPxClientUploadControl.FileUploadComplete) events to automatically upload the selected file and update the cell value after:

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

5. Handle the upload control's [FileUploadComplete](https://docs.devexpress.com/AspNet/DevExpress.Web.ASPxUploadControl.FileUploadComplete) event to store the uploaded file in the session:

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

Now you can access all the uploaded files in the [BatchUpdate](https://docs.devexpress.com/AspNet/DevExpress.Web.ASPxGridBase.BatchUpdate) event handler. Clear the session storage after you have updated the files.

## Files to Review

* [Default.aspx](./CS/Default.aspx) (VB: [Default.aspx](./VB/Default.aspx))
* [Default.aspx.cs](./CS/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/Default.aspx.vb))

## More Examples

*[Grid View for ASP.NET Web Forms - How to implement an edit item template in batch mode](https://github.com/DevExpress-Examples/asp-net-web-forms-grid-edit-item-template-in-batch-mode)
*[GridView for ASP.NET MVC - How to use the upload control in batch edit mode](https://github.com/DevExpress-Examples/asp-net-mvc-grid-use-upload-control-in-batch-edit-mode)

