Option Infer On

Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports DevExpress.Web

Partial Public Class _Default
	Inherits System.Web.UI.Page

	Public Property Files() As Dictionary(Of Object, Byte())
		Get
			If Session("files") Is Nothing Then
				Session("files") = New Dictionary(Of Object, Byte())()
			End If
			Return TryCast(Session("files"), Dictionary(Of Object, Byte()))
		End Get
		Set(ByVal value As Dictionary(Of Object, Byte()))
			Session("files") = value
		End Set
	End Property

	Protected Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs)
		ASPxGridView1.DataSource = Enumerable.Range(0, 10).Select(Function(i) New With {
			Key .ID = i,
			Key .PersonName = "Name " & i,
			Key .FileName = ""
		})
		ASPxGridView1.DataBind()

	End Sub
	Protected Sub ASPxUploadControl1_FileUploadComplete(ByVal sender As Object, ByVal e As FileUploadCompleteEventArgs)
		Dim name = e.UploadedFile.FileName
		e.CallbackData = name

		If Files.ContainsKey(hiddenField("visibleIndex")) Then
			Files(hiddenField("visibleIndex")) = e.UploadedFile.FileBytes
		Else
			Files.Add(hiddenField("visibleIndex"), e.UploadedFile.FileBytes)
		End If
	End Sub
	Protected Sub ASPxGridView1_BatchUpdate(ByVal sender As Object, ByVal e As DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs)
		'update the datasource here using the uploaded files
		'clear the dictionary after
		Files.Clear()
	End Sub
	Protected Sub ASPxGridView1_CustomErrorText(ByVal sender As Object, ByVal e As ASPxGridViewCustomErrorTextEventArgs)
		If e.Exception.GetType() Is GetType(NotSupportedException) Then
			e.ErrorText = "Online data modification is not supported. Download the example and implement your logic in the BatchUpdate event handler."
		End If
	End Sub
	Protected Sub ASPxGridView1_BeforeGetCallbackResult(ByVal sender As Object, ByVal e As EventArgs)
		Files.Clear()
	End Sub
End Class