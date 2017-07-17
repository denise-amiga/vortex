Strict

Private
Import renderer
Import texture

Public
Class Framebuffer
Public
	Function Create:Framebuffer(width:Int, height:Int, depthBuffer:Bool)
		Local fb:Framebuffer = New Framebuffer
		fb.mColorTex = Texture.Create(width, height)
		If depthBuffer Then fb.mDepthBuffer = Renderer.CreateRenderbuffer(width, height)
		'If depthEnabled Then fb.mDepthTex = Texture.Create(width, height, True); depthHandle = fb.mDepthTex.Handle
		fb.mHandle = Renderer.CreateFramebuffer(fb.mColorTex.Handle, fb.mDepthBuffer)
		Return fb
	End
	
	Method Free:Void()
		If mColorTex Then mColorTex.Free()
		'If mDepthTex Then mDepthTex.Free()
		If mDepthBuffer > 0 Then Renderer.FreeRenderbuffer(mDepthBuffer)
		Renderer.FreeFramebuffer(mHandle)
	End
	
	Method Set:Void()
		Renderer.SetFramebuffer(mHandle)
	End
	
	Function SetScreen:Void()
		Renderer.SetFramebuffer(0)
	End
	
	Method Handle:Int() Property
		Return mHandle
	End
	
	Method ColorTexture:Texture() Property
		Return mColorTex
	End
	
	'Method DepthTexture:Texture() Property
	'	Return mDepthTex
	'End
	
	Method HasDepthBuffer:Bool() Property
		Return mDepthBuffer
	End
Private
	Method New()
	End
	
	Field mHandle		: Int
	Field mColorTex		: Texture
	Field mDepthBuffer	: Int
	'Field mDepthTex	: Texture
End
