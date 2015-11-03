(* Application.applescript *)

(* ==== Globals ==== *)

global sourcetext, thisinfo, translationmodetext


(* ==== Event Handlers ==== *)

on clicked theObject
	set speakFlag to title of theObject
	
	if (speakFlag = "Speak translated text") then
		set volumevalue to contents of slider "volumeslider" of window "Language Translator" as integer
		tell application "Finder"
			set volume volumevalue
		end tell
		say thisinfo using "Bruce"
	else if (speakFlag = "Translate") then
		tell progress indicator "progressBar" of window "Language Translator" to start
		
		set translationmodetext to title of popup button 1 of window "Language Translator"
		
		if translationmodetext = "English -> French" then
			set translationmodecode to "en_fr"
		else if translationmodetext = "English -> German" then
			set translationmodecode to "en_de"
		else if translationmodetext = "English -> Italian" then
			set translationmodecode to "en_it"
		else if translationmodetext = "English -> Portugese" then
			set translationmodecode to "en_pt"
		else if translationmodetext = "English -> Spanish" then
			set translationmodecode to "en_es"
		else if translationmodetext = "French -> English" then
			set translationmodecode to "fr_en"
		else if translationmodetext = "German -> English" then
			set translationmodecode to "de_en"
		else if translationmodetext = "Italian -> English" then
			set translationmodecode to "it_en"
		else if translationmodetext = "Portugese -> English" then
			set translationmodecode to "pt_en"
		else if translationmodetext = "Russian -> English" then
			set translationmodecode to "ru_en"
		else if translationmodetext = "Spanish -> English" then
			set translationmodecode to "es_en"
		end if
		
		set sourcetext to contents of text view "Original Text" of scroll view 1 of box "Original Text" of split view 1 of window "Language Translator"
		try
			-- SOAP CALL
			tell application "http://services.xmethods.net:80/perl/soaplite.cgi"
				set thisinfo to call soap {method name:"BabelFish", method namespace uri:"urn:xmethodsBabelFish", parameters:{translationmode:translationmodecode, sourcedata:my getPlainText(sourcetext)}, SOAPAction:"urn:xmethodsBabelFish#BabelFish"}
			end tell
			
		on error errMsg number errNum
			tell progress indicator "progressBar" of window "Language Translator" to stop
			set the contents of text view 1 of scroll view 1 of box "Translated Text" of split view 1 of window "Language Translator" to errMsg & " " & errNum & return & return & "Are you connected to the Internet?"
		end try
		
		set the contents of text view 1 of scroll view 1 of box "Translated Text" of split view 1 of window "Language Translator" to thisinfo as string
		
		set enabled of button "Speak translated text" of window 1 to true
		tell progress indicator "progressBar" of window "Language Translator" to stop
	end if
	
	
end clicked

on action theObject
	display dialog "Setting volume"
	set enabled of slider of window "Language Translator" to true
	set volumevalue to contents of slider "volumeslider" of window "Language Translator" as integer
	set volume volumevalue
end action

on choose menu item theObject
	set menuItemTitle to title of theObject as string
	if menuItemTitle = "New" then
		display dialog "Feature coming soon…" giving up after 3 attached to window "Language Translator"
	end if
	if menuItemTitle = "Save" then
		set saveFile to choose file name with prompt "Save File to" default name "Translated Text"
		set fileRef to open for access saveFile with write permission
		write "Translation: " & translationmodetext & return & return & "Original Text: " & return & return & sourcetext & return & return & "Translated Text: " & return & return & thisinfo to fileRef
		close access fileRef
	end if
end choose menu item

on update menu item theObject
	(*Add your script here.*)
end update menu item

on awake from nib theObject
	set uses threaded animation of theObject to true
end awake from nib

on getPlainText(fromUnicodeString)
	set styledText to fromUnicodeString as string
	set styledRecord to styledText as record
	return «class ktxt» of styledRecord
end getPlainText

(* © Copyright 2002 Apple Computer, Inc. All rights reserved.

IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. (“Apple”) in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this Apple software constitutes acceptance of these terms.  If you do not agree with these terms, please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Apple grants you a personal, non-exclusive license, under Apple’s copyrights in this original Apple software (the “Apple Software”), to use, reproduce, modify and redistribute the Apple Software, with or without modifications, in source and/or binary forms; provided that if you redistribute the Apple Software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the Apple Software.  Neither the name, trademarks, service marks or logos of Apple Computer, Inc. may be used to endorse or promote products derived from the Apple Software without specific prior written permission from Apple.  Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Apple herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. *)
