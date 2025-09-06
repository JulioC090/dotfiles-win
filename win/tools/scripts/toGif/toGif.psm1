<#
.SYNOPSIS
  Convert a video file to an animated GIF using ffmpeg.

.DESCRIPTION
  This script generates a GIF from a video file.
  Optional parameters allow setting output filename, width, and frames per second (FPS).

.PARAMETER InputFile
  Path to the input video file. Required.

.PARAMETER OutputFile
  Path for the output GIF. Default is 'output.gif'.

.PARAMETER Width
  Horizontal resolution for the GIF. If not specified, the script will use the input video width.

.PARAMETER Fps
  Frames per second for the GIF. Default is 30.

.EXAMPLE
  toGif -InputFile video.mp4

.EXAMPLE
  toGif -i video.mp4 -o animated.gif -w 640 -f 24
#>

function toGif {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [Alias("i")]
    [string] $InputFile,

    [Alias("o")]
    [string] $OutputFile = "output.gif",

    [Alias("w")]
    [int] $Width,

    [Alias("f")]
    [int] $Fps = 30
  )

  # Check if input file exists
  if (-not (Test-Path $InputFile)) {
      Write-Host "Input file '$InputFile' does not exist."
      return
  }

  # Validate FPS
  if ($Fps -le 0) {
      Write-Host "FPS must be a positive integer."
      return
  }

  # Validate Width (if provided)
  if ($Width -and $Width -le 0) {
      Write-Host "Width must be a positive integer."
      return
  }

  # Check if ffmpeg is installed
  if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
      Write-Host "FFmpeg not found on this system."
      Write-Host "You can install it with:"
      Write-Host "`twinget install `"FFmpeg (Essentials Build)`""
      return
  }

  # If Width is not provided, get the input video width
  if (-not $Width) {
      try {
          $videoInfo = & ffprobe -v error -select_streams v:0 -show_entries stream=width `
                      -of default=noprint_wrappers=1:nokey=1 $InputFile
          $Width = [int]$videoInfo
          Write-Host "Using detected video width: $Width px"
      }
      catch {
          Write-Host "Could not retrieve the video width."
          return
      }
  }

  # If OutputFile already exists, confirm before overwriting
  if (Test-Path $OutputFile) {
      $response = Read-Host "The file '$OutputFile' already exists. Do you want to overwrite it? (y/n)"
      if ($response -ne "y" -and $response -ne "Y") {
          Write-Host "Operation canceled."
          return
      }
  }

  # Create a temporary palette file
  $palette = [System.IO.Path]::GetTempFileName() + ".png"

  # Define filters
  $filters = "fps=${Fps},scale=${Width}:-1:flags=lanczos"

  # Generate the palette
  & ffmpeg -v warning -i $InputFile -vf "$filters,palettegen" -y $palette

  # Generate the GIF using the palette
  & ffmpeg -v warning -i $InputFile -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $OutputFile

  # Remove the temporary palette
  Remove-Item -Force $palette

  Write-Host "GIF successfully created: $OutputFile"
}

Export-ModuleMember -Function toGif