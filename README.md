# Pose Thumbnail Provider

## Overview

This small shell extension provides image previews in Windows Explorer for `.pose` files. `.Pose` files are created by Anamnesis / Brio / Ktisis - posing tools for FFXIV. 

Pose files can contain an optional json property named `Base64Image` which contains the image preview for the file. Brio supports displaying the image in it's built in file browser. 

I wanted to be able to also see this in Windows in Explorer, so, thus this project.

## Implementation details

It's a very simple C# implementation of a Windows Shell Extension, using `SharpShell` as the library for easy creation.
Because SharpShell dlls use .Net Framework, you are limited to the kinds of C# features and libraries supported by it, and also, external dependencies should be kept at a minimum. 
Also, throwing exceptions during the shell extension runtime is not a good idea and can cause problems.

The project also contains a Inno setup script to create the installer.

## Other notes

Not handled by the installer, but, the provider will also write debug logs to `%LOCALAPPDATA%\PoseThumbnailProvider\thumb.log` if you set the registry key:

`HKLM\SOFTWARE\PoseThumbnailProvider\Logging` = 1 (dword)

