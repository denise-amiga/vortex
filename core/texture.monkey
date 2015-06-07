Strict

Private
Import brl.databuffer
Import vortex.core.renderer

Public
Class Texture Final
Public
	Const FILTER_NONE% = Renderer.FILTER_NONE
	Const FILTER_LINEAR% = Renderer.FILTER_LINEAR
	Const FILTER_BILINEAR% = Renderer.FILTER_BILINEAR
	Const FILTER_TRILINEAR% = Renderer.FILTER_TRILINEAR
	
	Function Create:Texture(filename$, filter%)
		Local handle% = Renderer.LoadTexture(filename, mSizeArr, filter)
		If mSizeArr[0] > 0
			Local tex:Texture = New Texture
			tex.mFilename = filename
			tex.mHandle = handle
			tex.mWidth = mSizeArr[0]
			tex.mHeight = mSizeArr[1]
			Return tex
		Else
			Return Null
		End
	End
	
	Method Discard:Void()
		Renderer.FreeTexture(mHandle)
	End
	
	Method GetFilename$()
		Return mFilename
	End
	
	Method GetHandle%()
		Return mHandle
	End
	
	Method GetWidth%()
		Return mWidth
	End
	
	Method GetHeight%()
		Return mHeight
	End
	
	Method Draw:Void(x#, y#, width# = 0, height# = 0, rectx# = 0, recty# = 0, rectwidth# = 0, rectheight# = 0)
		If rectwidth = 0 Then rectwidth = GetWidth()
		If rectheight = 0 Then rectheight = GetHeight()
		If width = 0 Then width = rectwidth
		If height = 0 Then height = rectheight
		
		'Calculate texcoords in 0..1 range, independently from frame
		Local u0# = rectx / GetWidth()
		Local v0# = recty / GetHeight()
		Local u1# = (rectx + rectwidth) / GetWidth()
		Local v1# = (recty + rectheight) / GetHeight()
		
		'Fill buffer
		mBuffer.PokeFloat(0, x)
		mBuffer.PokeFloat(4, y)
		mBuffer.PokeFloat(8, 0)
		mBuffer.PokeFloat(12, x+width)
		mBuffer.PokeFloat(16, y)
		mBuffer.PokeFloat(20, 0)
		mBuffer.PokeFloat(24, x)
		mBuffer.PokeFloat(28, y+height)
		mBuffer.PokeFloat(32, 0)
		mBuffer.PokeFloat(36, x+width)
		mBuffer.PokeFloat(40, y+height)
		mBuffer.PokeFloat(44, 0)
		mBuffer.PokeFloat(48, u0)
		mBuffer.PokeFloat(52, v0)
		mBuffer.PokeFloat(56, u1)
		mBuffer.PokeFloat(60, v0)
		mBuffer.PokeFloat(64, u0)
		mBuffer.PokeFloat(68, v1)
		mBuffer.PokeFloat(72, u1)
		mBuffer.PokeFloat(76, v1)
		
		'Render
		Renderer.SetTexture(mHandle)
		Renderer.DrawTexRect(mBuffer)
		Renderer.SetTexture(0)
	End
Private
	Method New()
	End
	
	Field mFilename	: String
	Field mHandle	: Int
	Field mWidth	: Int
	Field mHeight	: Int
	Global mSizeArr	: Int[2]
	Global mBuffer	: DataBuffer = New DataBuffer(80)
End