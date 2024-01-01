local ffi = require("ffi")
local sdl = require("sdl")

local GLEW = {
}

ffi.cdef[[
typedef void (__stdcall * PFNGLTEXSTORAGE2DPROC) (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height);

//typedef void (__stdcall * PFNGLCREATEFRAMEBUFFERSPROC) (GLsizei n, GLuint* framebuffers);
typedef void (__stdcall * PFNGLGENFRAMEBUFFERSPROC) (GLsizei n, GLuint* framebuffers);
typedef void (__stdcall * PFNGLBINDFRAMEBUFFEREXTPROC) (GLenum target, GLuint framebuffer);
typedef void (__stdcall * PFNGLFRAMEBUFFERTEXTURE2DEXTPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);

typedef void (__stdcall * PFNGLATTACHSHADERPROC) (GLuint program, GLuint shader);
typedef void (__stdcall * PFNGLBINDATTRIBLOCATIONPROC) (GLuint program, GLuint index, const GLchar* name);
typedef void (__stdcall * PFNGLBLENDEQUATIONSEPARATEPROC) (GLenum modeRGB, GLenum modeAlpha);
typedef void (__stdcall * PFNGLCOMPILESHADERPROC) (GLuint shader);
typedef GLuint (__stdcall * PFNGLCREATEPROGRAMPROC) (void);
typedef GLuint (__stdcall * PFNGLCREATESHADERPROC) (GLenum type);
typedef void (__stdcall * PFNGLDELETEPROGRAMPROC) (GLuint program);
typedef void (__stdcall * PFNGLDELETESHADERPROC) (GLuint shader);
typedef void (__stdcall * PFNGLDETACHSHADERPROC) (GLuint program, GLuint shader);
typedef void (__stdcall * PFNGLDISABLEVERTEXATTRIBARRAYPROC) (GLuint index);
typedef void (__stdcall * PFNGLDRAWBUFFERSPROC) (GLsizei n, const GLenum* bufs);
typedef void (__stdcall * PFNGLENABLEVERTEXATTRIBARRAYPROC) (GLuint index);
typedef void (__stdcall * PFNGLGETACTIVEATTRIBPROC) (GLuint program, GLuint index, GLsizei maxLength, GLsizei* length, GLint* size, GLenum* type, GLchar* name);
typedef void (__stdcall * PFNGLGETACTIVEUNIFORMPROC) (GLuint program, GLuint index, GLsizei maxLength, GLsizei* length, GLint* size, GLenum* type, GLchar* name);
typedef void (__stdcall * PFNGLGETATTACHEDSHADERSPROC) (GLuint program, GLsizei maxCount, GLsizei* count, GLuint* shaders);
typedef GLint (__stdcall * PFNGLGETATTRIBLOCATIONPROC) (GLuint program, const GLchar* name);
typedef void (__stdcall * PFNGLGETPROGRAMINFOLOGPROC) (GLuint program, GLsizei bufSize, GLsizei* length, GLchar* infoLog);
typedef void (__stdcall * PFNGLGETPROGRAMIVPROC) (GLuint program, GLenum pname, GLint* param);
typedef void (__stdcall * PFNGLGETSHADERINFOLOGPROC) (GLuint shader, GLsizei bufSize, GLsizei* length, GLchar* infoLog);
typedef void (__stdcall * PFNGLGETSHADERSOURCEPROC) (GLuint obj, GLsizei maxLength, GLsizei* length, GLchar* source);
typedef void (__stdcall * PFNGLGETSHADERIVPROC) (GLuint shader, GLenum pname, GLint* param);
typedef GLint (__stdcall * PFNGLGETUNIFORMLOCATIONPROC) (GLuint program, const GLchar* name);
typedef void (__stdcall * PFNGLGETUNIFORMFVPROC) (GLuint program, GLint location, GLfloat* params);
typedef void (__stdcall * PFNGLGETUNIFORMIVPROC) (GLuint program, GLint location, GLint* params);
typedef void (__stdcall * PFNGLGETVERTEXATTRIBPOINTERVPROC) (GLuint index, GLenum pname, void** pointer);
typedef void (__stdcall * PFNGLGETVERTEXATTRIBDVPROC) (GLuint index, GLenum pname, GLdouble* params);
typedef void (__stdcall * PFNGLGETVERTEXATTRIBFVPROC) (GLuint index, GLenum pname, GLfloat* params);
typedef void (__stdcall * PFNGLGETVERTEXATTRIBIVPROC) (GLuint index, GLenum pname, GLint* params);
typedef GLboolean (__stdcall * PFNGLISPROGRAMPROC) (GLuint program);
typedef GLboolean (__stdcall * PFNGLISSHADERPROC) (GLuint shader);
typedef void (__stdcall * PFNGLLINKPROGRAMPROC) (GLuint program);
typedef void (__stdcall * PFNGLSHADERSOURCEPROC) (GLuint shader, GLsizei count, const GLchar *const* string, const GLint* length);
typedef void (__stdcall * PFNGLSTENCILFUNCSEPARATEPROC) (GLenum frontfunc, GLenum backfunc, GLint ref, GLuint mask);
typedef void (__stdcall * PFNGLSTENCILMASKSEPARATEPROC) (GLenum face, GLuint mask);
typedef void (__stdcall * PFNGLSTENCILOPSEPARATEPROC) (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
typedef void (__stdcall * PFNGLUNIFORM1FPROC) (GLint location, GLfloat v0);
typedef void (__stdcall * PFNGLUNIFORM1FVPROC) (GLint location, GLsizei count, const GLfloat* value);
typedef void (__stdcall * PFNGLUNIFORM1IPROC) (GLint location, GLint v0);
typedef void (__stdcall * PFNGLUNIFORM1IVPROC) (GLint location, GLsizei count, const GLint* value);
typedef void (__stdcall * PFNGLUNIFORM2FPROC) (GLint location, GLfloat v0, GLfloat v1);
typedef void (__stdcall * PFNGLUNIFORM2FVPROC) (GLint location, GLsizei count, const GLfloat* value);
typedef void (__stdcall * PFNGLUNIFORM2IPROC) (GLint location, GLint v0, GLint v1);
typedef void (__stdcall * PFNGLUNIFORM2IVPROC) (GLint location, GLsizei count, const GLint* value);
typedef void (__stdcall * PFNGLUNIFORM3FPROC) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
typedef void (__stdcall * PFNGLUNIFORM3FVPROC) (GLint location, GLsizei count, const GLfloat* value);
typedef void (__stdcall * PFNGLUNIFORM3IPROC) (GLint location, GLint v0, GLint v1, GLint v2);
typedef void (__stdcall * PFNGLUNIFORM3IVPROC) (GLint location, GLsizei count, const GLint* value);
typedef void (__stdcall * PFNGLUNIFORM4FPROC) (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
typedef void (__stdcall * PFNGLUNIFORM4FVPROC) (GLint location, GLsizei count, const GLfloat* value);
typedef void (__stdcall * PFNGLUNIFORM4IPROC) (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
typedef void (__stdcall * PFNGLUNIFORM4IVPROC) (GLint location, GLsizei count, const GLint* value);
typedef void (__stdcall * PFNGLUNIFORMMATRIX2FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
typedef void (__stdcall * PFNGLUNIFORMMATRIX3FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
typedef void (__stdcall * PFNGLUNIFORMMATRIX4FVPROC) (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
typedef void (__stdcall * PFNGLUSEPROGRAMPROC) (GLuint program);
typedef void (__stdcall * PFNGLVALIDATEPROGRAMPROC) (GLuint program);
typedef void (__stdcall * PFNGLVERTEXATTRIB1DPROC) (GLuint index, GLdouble x);
typedef void (__stdcall * PFNGLVERTEXATTRIB1DVPROC) (GLuint index, const GLdouble* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB1FPROC) (GLuint index, GLfloat x);
typedef void (__stdcall * PFNGLVERTEXATTRIB1FVPROC) (GLuint index, const GLfloat* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB1SPROC) (GLuint index, GLshort x);
typedef void (__stdcall * PFNGLVERTEXATTRIB1SVPROC) (GLuint index, const GLshort* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB2DPROC) (GLuint index, GLdouble x, GLdouble y);
typedef void (__stdcall * PFNGLVERTEXATTRIB2DVPROC) (GLuint index, const GLdouble* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB2FPROC) (GLuint index, GLfloat x, GLfloat y);
typedef void (__stdcall * PFNGLVERTEXATTRIB2FVPROC) (GLuint index, const GLfloat* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB2SPROC) (GLuint index, GLshort x, GLshort y);
typedef void (__stdcall * PFNGLVERTEXATTRIB2SVPROC) (GLuint index, const GLshort* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB3DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z);
typedef void (__stdcall * PFNGLVERTEXATTRIB3DVPROC) (GLuint index, const GLdouble* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB3FPROC) (GLuint index, GLfloat x, GLfloat y, GLfloat z);
typedef void (__stdcall * PFNGLVERTEXATTRIB3FVPROC) (GLuint index, const GLfloat* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB3SPROC) (GLuint index, GLshort x, GLshort y, GLshort z);
typedef void (__stdcall * PFNGLVERTEXATTRIB3SVPROC) (GLuint index, const GLshort* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4NBVPROC) (GLuint index, const GLbyte* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4NIVPROC) (GLuint index, const GLint* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4NSVPROC) (GLuint index, const GLshort* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4NUBPROC) (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
typedef void (__stdcall * PFNGLVERTEXATTRIB4NUBVPROC) (GLuint index, const GLubyte* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4NUIVPROC) (GLuint index, const GLuint* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4NUSVPROC) (GLuint index, const GLushort* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4BVPROC) (GLuint index, const GLbyte* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4DPROC) (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
typedef void (__stdcall * PFNGLVERTEXATTRIB4DVPROC) (GLuint index, const GLdouble* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4FPROC) (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
typedef void (__stdcall * PFNGLVERTEXATTRIB4FVPROC) (GLuint index, const GLfloat* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4IVPROC) (GLuint index, const GLint* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4SPROC) (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
typedef void (__stdcall * PFNGLVERTEXATTRIB4SVPROC) (GLuint index, const GLshort* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4UBVPROC) (GLuint index, const GLubyte* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4UIVPROC) (GLuint index, const GLuint* v);
typedef void (__stdcall * PFNGLVERTEXATTRIB4USVPROC) (GLuint index, const GLushort* v);
typedef void (__stdcall * PFNGLVERTEXATTRIBPOINTERPROC) (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void* pointer);

// GLEW
typedef void (__stdcall * PFNGLBINDFRAMEBUFFERPROC) (GLenum target, GLuint framebuffer);
typedef void (__stdcall * PFNGLBINDRENDERBUFFERPROC) (GLenum target, GLuint renderbuffer);
typedef void (__stdcall * PFNGLBLITFRAMEBUFFERPROC) (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
typedef GLenum (__stdcall * PFNGLCHECKFRAMEBUFFERSTATUSPROC) (GLenum target);
typedef void (__stdcall * PFNGLDELETEFRAMEBUFFERSPROC) (GLsizei n, const GLuint* framebuffers);
typedef void (__stdcall * PFNGLDELETERENDERBUFFERSPROC) (GLsizei n, const GLuint* renderbuffers);
typedef void (__stdcall * PFNGLFRAMEBUFFERRENDERBUFFERPROC) (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
typedef void (__stdcall * PFNGLFRAMEBUFFERTEXTURE1DPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
typedef void (__stdcall * PFNGLFRAMEBUFFERTEXTURE2DPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
typedef void (__stdcall * PFNGLFRAMEBUFFERTEXTURE3DPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint layer);
typedef void (__stdcall * PFNGLFRAMEBUFFERTEXTURELAYERPROC) (GLenum target,GLenum attachment, GLuint texture,GLint level,GLint layer);
typedef void (__stdcall * PFNGLGENFRAMEBUFFERSPROC) (GLsizei n, GLuint* framebuffers);
typedef void (__stdcall * PFNGLGENRENDERBUFFERSPROC) (GLsizei n, GLuint* renderbuffers);
typedef void (__stdcall * PFNGLGENERATEMIPMAPPROC) (GLenum target);
typedef void (__stdcall * PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC) (GLenum target, GLenum attachment, GLenum pname, GLint* params);
typedef void (__stdcall * PFNGLGETRENDERBUFFERPARAMETERIVPROC) (GLenum target, GLenum pname, GLint* params);
typedef GLboolean (__stdcall * PFNGLISFRAMEBUFFERPROC) (GLuint framebuffer);
typedef GLboolean (__stdcall * PFNGLISRENDERBUFFERPROC) (GLuint renderbuffer);
typedef void (__stdcall * PFNGLRENDERBUFFERSTORAGEPROC) (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (__stdcall * PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC) (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);

// GL 1.5
typedef ptrdiff_t GLintptr;
typedef ptrdiff_t GLsizeiptr;

typedef void (__stdcall * PFNGLBEGINQUERYPROC) (GLenum target, GLuint id);
typedef void (__stdcall * PFNGLBINDBUFFERPROC) (GLenum target, GLuint buffer);
typedef void (__stdcall * PFNGLBUFFERDATAPROC) (GLenum target, GLsizeiptr size, const void* data, GLenum usage);
typedef void (__stdcall * PFNGLBUFFERSUBDATAPROC) (GLenum target, GLintptr offset, GLsizeiptr size, const void* data);
typedef void (__stdcall * PFNGLDELETEBUFFERSPROC) (GLsizei n, const GLuint* buffers);
typedef void (__stdcall * PFNGLDELETEQUERIESPROC) (GLsizei n, const GLuint* ids);
typedef void (__stdcall * PFNGLENDQUERYPROC) (GLenum target);
typedef void (__stdcall * PFNGLGENBUFFERSPROC) (GLsizei n, GLuint* buffers);
typedef void (__stdcall * PFNGLGENQUERIESPROC) (GLsizei n, GLuint* ids);
typedef void (__stdcall * PFNGLGETBUFFERPARAMETERIVPROC) (GLenum target, GLenum pname, GLint* params);
typedef void (__stdcall * PFNGLGETBUFFERPOINTERVPROC) (GLenum target, GLenum pname, void** params);
typedef void (__stdcall * PFNGLGETBUFFERSUBDATAPROC) (GLenum target, GLintptr offset, GLsizeiptr size, void* data);
typedef void (__stdcall * PFNGLGETQUERYOBJECTIVPROC) (GLuint id, GLenum pname, GLint* params);
typedef void (__stdcall * PFNGLGETQUERYOBJECTUIVPROC) (GLuint id, GLenum pname, GLuint* params);
typedef void (__stdcall * PFNGLGETQUERYIVPROC) (GLenum target, GLenum pname, GLint* params);
typedef GLboolean (__stdcall * PFNGLISBUFFERPROC) (GLuint buffer);
typedef GLboolean (__stdcall * PFNGLISQUERYPROC) (GLuint id);
typedef void* (__stdcall * PFNGLMAPBUFFERPROC) (GLenum target, GLenum access);
typedef GLboolean (__stdcall * PFNGLUNMAPBUFFERPROC) (GLenum target);
]]

function create_function( proc_name, call_name )
	GLEW[call_name] = ffi.cast(proc_name, sdl.SDL_GL_GetProcAddress(call_name))
end

function GLEW.init()
	GLEW.glTexStorage2D = ffi.cast("PFNGLTEXSTORAGE2DPROC", sdl.SDL_GL_GetProcAddress("glTexStorage2D"))
	
	
	GLEW.glGenFramebuffers = ffi.cast("PFNGLGENFRAMEBUFFERSPROC", sdl.SDL_GL_GetProcAddress("glGenFramebuffers"))
	GLEW.glBindFramebuffer = ffi.cast("PFNGLBINDFRAMEBUFFEREXTPROC", sdl.SDL_GL_GetProcAddress("glBindFramebuffer"))
	GLEW.glFramebufferTexture2D = ffi.cast("PFNGLFRAMEBUFFERTEXTURE2DEXTPROC", sdl.SDL_GL_GetProcAddress("glFramebufferTexture2D"))
	
	
	GLEW.glAttachShader = ffi.cast("PFNGLATTACHSHADERPROC", sdl.SDL_GL_GetProcAddress("glAttachShader"))
	
	-- TODO: Make all declarations use this or make some readable files to load instead
	create_function("PFNGLBINDATTRIBLOCATIONPROC", "glBindAttribLocation")
	create_function("PFNGLBLENDEQUATIONSEPARATEPROC", "glBlendEquationSeparate")
	create_function("PFNGLCOMPILESHADERPROC", "glCompileShader")
	create_function("PFNGLCREATEPROGRAMPROC", "glCreateProgram")
	create_function("PFNGLCREATESHADERPROC", "glCreateShader")
	create_function("PFNGLDELETEPROGRAMPROC", "glDeleteProgram")
	create_function("PFNGLDELETESHADERPROC", "glDeleteShader")
	create_function("PFNGLDETACHSHADERPROC", "glDetachShader")
	create_function("PFNGLDISABLEVERTEXATTRIBARRAYPROC", "glDisableVertexAttribArray")
	create_function("PFNGLDRAWBUFFERSPROC", "glDrawBuffers")
	create_function("PFNGLENABLEVERTEXATTRIBARRAYPROC", "glEnableVertexAttribArray")
	create_function("PFNGLGETACTIVEATTRIBPROC", "glGetActiveAttrib")
	create_function("PFNGLGETACTIVEUNIFORMPROC", "glGetActiveUniform")
	create_function("PFNGLGETATTACHEDSHADERSPROC", "glGetAttachedShaders")
	create_function("PFNGLGETATTRIBLOCATIONPROC", "glGetAttribLocation")
	create_function("PFNGLGETPROGRAMINFOLOGPROC", "glGetProgramInfoLog")
	create_function("PFNGLGETPROGRAMIVPROC", "glGetProgramiv")
	create_function("PFNGLGETSHADERINFOLOGPROC", "glGetShaderInfoLog")
	create_function("PFNGLGETSHADERSOURCEPROC", "glGetShaderSource")
	create_function("PFNGLGETSHADERIVPROC", "glGetShaderiv")
	create_function("PFNGLGETUNIFORMLOCATIONPROC", "glGetUniformLocation")
	create_function("PFNGLGETUNIFORMFVPROC", "glGetUniformfv")
	create_function("PFNGLGETUNIFORMIVPROC", "glGetUniformiv")
	create_function("PFNGLGETVERTEXATTRIBPOINTERVPROC", "glGetVertexAttribPointerv")
	create_function("PFNGLGETVERTEXATTRIBDVPROC", "glGetVertexAttribdv")
	create_function("PFNGLGETVERTEXATTRIBFVPROC", "glGetVertexAttribfv")
	create_function("PFNGLGETVERTEXATTRIBIVPROC", "glGetVertexAttribiv")
	create_function("PFNGLISPROGRAMPROC", "glIsProgram")
	create_function("PFNGLISSHADERPROC", "glIsShader")
	create_function("PFNGLLINKPROGRAMPROC", "glLinkProgram")
	create_function("PFNGLSHADERSOURCEPROC", "glShaderSource")
	create_function("PFNGLSTENCILFUNCSEPARATEPROC", "glStencilFuncSeparate")
	create_function("PFNGLSTENCILMASKSEPARATEPROC", "glStencilMaskSeparate")
	create_function("PFNGLSTENCILOPSEPARATEPROC", "glStencilOpSeparate")
	create_function("PFNGLUNIFORM1FPROC", "glUniform1f")
	create_function("PFNGLUNIFORM1FVPROC", "glUniform1fv")
	create_function("PFNGLUNIFORM1IPROC", "glUniform1i")
	create_function("PFNGLUNIFORM1IVPROC", "glUniform1iv")
	create_function("PFNGLUNIFORM2FPROC", "glUniform2f")
	create_function("PFNGLUNIFORM2FVPROC", "glUniform2fv")
	create_function("PFNGLUNIFORM2IPROC", "glUniform2i")
	create_function("PFNGLUNIFORM2IVPROC", "glUniform2iv")
	create_function("PFNGLUNIFORM3FPROC", "glUniform3f")
	create_function("PFNGLUNIFORM3FVPROC", "glUniform3fv")
	create_function("PFNGLUNIFORM3IPROC", "glUniform3i")
	create_function("PFNGLUNIFORM3IVPROC", "glUniform3iv")
	create_function("PFNGLUNIFORM4FPROC", "glUniform4f")
	create_function("PFNGLUNIFORM4FVPROC", "glUniform4fv")
	create_function("PFNGLUNIFORM4IPROC", "glUniform4i")
	create_function("PFNGLUNIFORM4IVPROC", "glUniform4iv")
	create_function("PFNGLUNIFORMMATRIX2FVPROC", "glUniformMatrix2fv")
	create_function("PFNGLUNIFORMMATRIX3FVPROC", "glUniformMatrix3fv")
	create_function("PFNGLUNIFORMMATRIX4FVPROC", "glUniformMatrix4fv")
	create_function("PFNGLUSEPROGRAMPROC", "glUseProgram")
	create_function("PFNGLVALIDATEPROGRAMPROC", "glValidateProgram")
	create_function("PFNGLVERTEXATTRIB1DPROC", "glVertexAttrib1d")
	create_function("PFNGLVERTEXATTRIB1DVPROC", "glVertexAttrib1dv")
	create_function("PFNGLVERTEXATTRIB1FPROC", "glVertexAttrib1f")
	create_function("PFNGLVERTEXATTRIB1FVPROC", "glVertexAttrib1fv")
	create_function("PFNGLVERTEXATTRIB1SPROC", "glVertexAttrib1s")
	create_function("PFNGLVERTEXATTRIB1SVPROC", "glVertexAttrib1sv")
	create_function("PFNGLVERTEXATTRIB2DPROC", "glVertexAttrib2d")
	create_function("PFNGLVERTEXATTRIB2DVPROC", "glVertexAttrib2dv")
	create_function("PFNGLVERTEXATTRIB2FPROC", "glVertexAttrib2f")
	create_function("PFNGLVERTEXATTRIB2FVPROC", "glVertexAttrib2fv")
	create_function("PFNGLVERTEXATTRIB2SPROC", "glVertexAttrib2s")
	create_function("PFNGLVERTEXATTRIB2SVPROC", "glVertexAttrib2sv")
	create_function("PFNGLVERTEXATTRIB3DPROC", "glVertexAttrib3d")
	create_function("PFNGLVERTEXATTRIB3DVPROC", "glVertexAttrib3dv")
	create_function("PFNGLVERTEXATTRIB3FPROC", "glVertexAttrib3f")
	create_function("PFNGLVERTEXATTRIB3FVPROC", "glVertexAttrib3fv")
	create_function("PFNGLVERTEXATTRIB3SPROC", "glVertexAttrib3s")
	create_function("PFNGLVERTEXATTRIB3SVPROC", "glVertexAttrib3sv")
	create_function("PFNGLVERTEXATTRIB4NBVPROC", "glVertexAttrib4Nbv")
	create_function("PFNGLVERTEXATTRIB4NIVPROC", "glVertexAttrib4Niv")
	create_function("PFNGLVERTEXATTRIB4NSVPROC", "glVertexAttrib4Nsv")
	create_function("PFNGLVERTEXATTRIB4NUBPROC", "glVertexAttrib4Nub")
	create_function("PFNGLVERTEXATTRIB4NUBVPROC", "glVertexAttrib4Nubv")
	create_function("PFNGLVERTEXATTRIB4NUIVPROC", "glVertexAttrib4Nuiv")
	create_function("PFNGLVERTEXATTRIB4NUSVPROC", "glVertexAttrib4Nusv")
	create_function("PFNGLVERTEXATTRIB4BVPROC", "glVertexAttrib4bv")
	create_function("PFNGLVERTEXATTRIB4DPROC", "glVertexAttrib4d")
	create_function("PFNGLVERTEXATTRIB4DVPROC", "glVertexAttrib4dv")
	create_function("PFNGLVERTEXATTRIB4FPROC", "glVertexAttrib4f")
	create_function("PFNGLVERTEXATTRIB4FVPROC", "glVertexAttrib4fv")
	create_function("PFNGLVERTEXATTRIB4IVPROC", "glVertexAttrib4iv")
	create_function("PFNGLVERTEXATTRIB4SPROC", "glVertexAttrib4s")
	create_function("PFNGLVERTEXATTRIB4SVPROC", "glVertexAttrib4sv")
	create_function("PFNGLVERTEXATTRIB4UBVPROC", "glVertexAttrib4ubv")
	create_function("PFNGLVERTEXATTRIB4UIVPROC", "glVertexAttrib4uiv")
	create_function("PFNGLVERTEXATTRIB4USVPROC", "glVertexAttrib4usv")
	create_function("PFNGLVERTEXATTRIBPOINTERPROC", "glVertexAttribPointer")
	
	create_function("PFNGLBINDFRAMEBUFFERPROC", "glBindFramebuffer")
	create_function("PFNGLBINDRENDERBUFFERPROC", "glBindRenderbuffer")
	create_function("PFNGLBLITFRAMEBUFFERPROC", "glBlitFramebuffer")
	create_function("PFNGLCHECKFRAMEBUFFERSTATUSPROC", "glCheckFramebufferStatus")
	create_function("PFNGLDELETEFRAMEBUFFERSPROC", "glDeleteFramebuffers")
	create_function("PFNGLDELETERENDERBUFFERSPROC", "glDeleteRenderbuffers")
	create_function("PFNGLFRAMEBUFFERRENDERBUFFERPROC", "glFramebufferRenderbuffer")
	create_function("PFNGLFRAMEBUFFERTEXTURE1DPROC", "glFramebufferTexture1D")
	create_function("PFNGLFRAMEBUFFERTEXTURE2DPROC", "glFramebufferTexture2D")
	create_function("PFNGLFRAMEBUFFERTEXTURE3DPROC", "glFramebufferTexture3D")
	create_function("PFNGLFRAMEBUFFERTEXTURELAYERPROC", "glFramebufferTextureLayer")
	create_function("PFNGLGENFRAMEBUFFERSPROC", "glGenFramebuffers")
	create_function("PFNGLGENRENDERBUFFERSPROC", "glGenRenderbuffers")
	create_function("PFNGLGENERATEMIPMAPPROC", "glGenerateMipmap")
	create_function("PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC", "glGetFramebufferAttachmentParameteriv")
	create_function("PFNGLGETRENDERBUFFERPARAMETERIVPROC", "glGetRenderbufferParameteriv")
	create_function("PFNGLISFRAMEBUFFERPROC", "glIsFramebuffer")
	create_function("PFNGLISRENDERBUFFERPROC", "glIsRenderbuffer")
	create_function("PFNGLRENDERBUFFERSTORAGEPROC", "glRenderbufferStorage")
	create_function("PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC", "glRenderbufferStorageMultisample")
	--create_function("", "")
	
	create_function("PFNGLBEGINQUERYPROC", "glBeginQuery")
	create_function("PFNGLBINDBUFFERPROC", "glBindBuffer")
	create_function("PFNGLBUFFERDATAPROC", "glBufferData")
	create_function("PFNGLBUFFERSUBDATAPROC", "glBufferSubData")
	create_function("PFNGLDELETEBUFFERSPROC", "glDeleteBuffers")
	create_function("PFNGLDELETEQUERIESPROC", "glDeleteQueries")
	create_function("PFNGLENDQUERYPROC", "glEndQuery")
	create_function("PFNGLGENBUFFERSPROC", "glGenBuffers")
	create_function("PFNGLGENQUERIESPROC", "glGenQueries")
	create_function("PFNGLGETBUFFERPARAMETERIVPROC", "glGetBufferParameteriv")
	create_function("PFNGLGETBUFFERPOINTERVPROC", "glGetBufferPointerv")
	create_function("PFNGLGETBUFFERSUBDATAPROC", "glGetBufferSubData")
	create_function("PFNGLGETQUERYOBJECTIVPROC", "glGetQueryObjectiv")
	create_function("PFNGLGETQUERYOBJECTUIVPROC", "glGetQueryObjectuiv")
	create_function("PFNGLGETQUERYIVPROC", "glGetQueryiv")
	create_function("PFNGLISBUFFERPROC", "glIsBuffer")
	create_function("PFNGLISQUERYPROC", "glIsQuery")
	create_function("PFNGLMAPBUFFERPROC", "glMapBuffer")
	create_function("PFNGLUNMAPBUFFERPROC", "glUnmapBuffer")
end

return GLEW