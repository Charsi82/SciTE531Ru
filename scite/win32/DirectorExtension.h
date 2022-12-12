// SciTE - Scintilla based Text Editor
/** @file DirectorExtension.h
 ** Extension for communicating with a director program.
 **/
// Copyright 1998-2001 by Neil Hodgson <neilh@scintilla.org>
// The License.txt file describes the conditions under which this software may be distributed.

#ifndef DIRECTOREXTENSION_H
#define DIRECTOREXTENSION_H

class DirectorExtension : public Extension {
private:
	ExtensionAPI *host {};
	DirectorExtension() {} // Singleton
	// Deleted so DirectorExtension objects can not be copied.
	DirectorExtension(const DirectorExtension &) = delete;
	void operator=(const DirectorExtension &) = delete;

public:
	static DirectorExtension &Instance();

	// Implement the Extension interface
	bool Initialise(ExtensionAPI *host_) override;
	bool Finalise() noexcept override;
	bool Clear() override;
	bool Load(const char *filename) override;

	bool OnOpen(const char *path) override;
	bool OnSwitchFile(const char *path) override;
	bool OnSave(const char *path) override;
	bool OnChar(char ch) override;
	bool OnExecute(const char *cmd) override;
	bool OnSavePointReached() override;
	bool OnSavePointLeft() override;
	bool OnStyle(Scintilla::Position startPos, Scintilla::Position lengthDoc, int initStyle, StyleWriter *styler) override;

#ifdef RB_ODBCLK
	bool OnDoubleClick(int) override; //!-change-[OnDoubleClick]
#else
	bool OnDoubleClick() override;
#endif // RB_ODBCLK

#ifdef RB_ONCLICK
	bool OnClick(int) override; //!-add-[OnClick]
#endif // RB_ONCLICK

#ifdef RB_OMBU
	bool OnMouseButtonUp(int) override; //!-add-[OnMouseButtonUp]
#endif

#ifdef RB_OHSC
	bool OnHotSpotReleaseClick(int) override; //!-add-[OnHotSpotReleaseClick]
#endif

	bool OnUpdateUI() override;
	bool OnMarginClick() override;
	bool OnMacro(const char *command, const char *params) override;

	bool SendProperty(const char *prop) override;
	bool OnClose(const char *path) override;
	bool NeedsOnClose() override;

	// Allow messages through to extension
	void HandleStringMessage(const char *message);
};

#endif
