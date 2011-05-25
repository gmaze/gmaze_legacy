% Guillaume Maze: Codes for Matlab
% Version 1 1 04-Mar-2011
% 
% 		Contents from /Users/gmaze/matlab/codes
% 
% Last update: 2011 March 04, 18:36
% 
% Files in: colors/
% 	colors/bluewhitered                      - Blue, white, and red color map.
% 	colors/canom                             - Center the caxis on zero
% 	colors/clabelcmap                        - Create labels for colorbar
% 	colors/cmapa                             - change colormap for anomalies
% 	colors/colormap                          - Color look-up table.
% 	colors/colormap_cpt                      - builds a matlab colormap from a cpt file
% 	colors/cseason                           - Colormap for seasons
% 	colors/ctitle                            - Display Colorbar title.
% 	colors/logcolormap                       - Stretch a colormap extremum toward black and white
% 	colors/mycolormap                        - Change colormap resolution
% 	colors/mycolormaps_create                - H1LINE
% 	colors/newclim                           - Used to get more than 1 colormap in subplot windows
% 	colors/setcolormaps                      - Sets the colormap as the union of two at certain level.
% 	colors/test_vivid                        - M-file for test_vivid.fig
% 	colors/thincolorbar                      - Display thinner colorbar
% 	colors/thinnercolorbar                   - Change colorbars thickness in groups
% 	colors/unif                              - Uniformize colorscale on different figures
% 	colors/updatecolorbar                    - Update colorbars
% 	colors/vivid                             - Creates a Personalized Vivid Colormap
% 	colors/vivid_contrast                    - H1LINE
% 
% Files in: custom/
% 	custom/bibus                             - Give me the next bus
% 	custom/cbsnews                           - Open the CBS Evening News podcast with your browser
% 	custom/check_ethlog                      - Update and view the my IFREMER working timeline
% 	custom/cw                                - Move to working directory
% 	custom/figure_central                    - Returns customized parameters to create a figure
% 	custom/gcontact2maillist                 - Removed < and > from a Google contacts list
% 	custom/gfdsearch_bulkupload              - H1LINE
% 	custom/google_reader_to_timeline         - Google reader opml file to be used in Google Timeline
% 	custom/tex2html                          - LaTeX to Html converter for intranet
% 	custom/top                               - Give back informations about the memory use of Matlab
% 	custom/update_codes                      - Update meta informations for my Matlab Codes
% 	custom/wherearewe                        - Give back a string to identify your location
% 
% Files in: geophysic/
% 	geophysic/WOA05_grid                     - Read World Ocean Atlas 2005 grid
% 	geophysic/compute_air_sea_o2_flux        - Compute air-sea oxygen flux
% 	geophysic/constraint_jstar               - H1LINE
% 	geophysic/convert_oxygen                 - O2 unit conversion
% 	geophysic/convert_unit                   - Convert unit of oceanic concentration substance
% 	geophysic/csvreadargo                    - H1LINE
% 	geophysic/csvreadargo2                   - H1LINE
% 	geophysic/densjmd95                      - Density of sea water
% 	geophysic/dfromo                         - Compute distances of points from an origin
% 	geophysic/diagCatH                       - Compute a 3D field projection on a 2D surface
% 	geophysic/diagHatisoC                    - Compute iso-surface of a 3D field
% 	geophysic/diag_PV                        - PV = diag_PV(LON,LAT,DPT,SIGMATHETA,RHO)
% 	geophysic/dinterp3bin                    - Interpolate a 3D field
% 	geophysic/dinterp3bin_grid               - Compute the new grid for DINTERP3BIN interpolated fields
% 	geophysic/dlowerres                      - Reduce the resolution of a field
% 	geophysic/drawmpoly                      - drawpoly Draw a polygon on a map (using m_map)
% 	geophysic/dwn_nao                        - Download the monthly NAO index
% 	geophysic/fillgaps                       - Try to fill gaps in 2D geograpical field
% 	geophysic/getGRD                         - Compute horizontal gradient of a geographical field
% 	geophysic/get_elev_along_track           - elev_along_track Determine topograpahy along ship track
% 	geophysic/get_mld                        - Compute the mixed layer depth
% 	geophysic/get_mmld_along_track           - Get Boyer-Montegut MLD climatology along a track
% 	geophysic/get_occaclim_along_track       - get_occa_along_track H1LINE
% 	geophysic/get_ovide_track                - Load OVIDE track
% 	geophysic/get_thd                        - Determine the seasonal and main thermocline depths
% 	geophysic/get_woa_along_track            - Interpolate World Ocean Atlas data along a ship track
% 	geophysic/getdS                          - Compute 2D surface elements matrix
% 	geophysic/getdV                          - Compute 3D volume elements matrix
% 	geophysic/guiOCCA                        - GUI to OCCA dataset
% 	geophysic/lldist                         - Compute distance in m between two points on Earth
% 	geophysic/load_climOCCA                  - Load any climatological fields from OCCA
% 	geophysic/load_maskOCCA                  - Load any mask from OCCA
% 	geophysic/m_drawbox                      - Draw a rectangular box using m_line
% 	geophysic/oc_vmodes                      - Compute vertical mode solutions
% 	geophysic/piston_velocity                - Compute a gaz air-sea interface transfer velocity (piston velocity)
% 	geophysic/plotts                         - Plot Temperature, Salinity on a T,S diag
% 	geophysic/scalprod                       - Cross or dot product of two 3D scalar fields
% 	geophysic/schmidt_number                 - Compute a Schmidt number
% 	geophysic/select_1transect               - Extract only one transect from a campaign
% 	geophysic/simplify_unit                  - Simplify unit expression
% 	geophysic/typicalyear                    - Compute a typical year from a daily volume time serie
% 	geophysic/udunits                        - Unidata units library
% 
% Files in: graphicxFigures/
% 	graphicxFigures/algnfootnote             - Horizontal alignement of the footnote for export
% 	graphicxFigures/export                   - Export a figure to A4 color EPS format
% 	graphicxFigures/exportf                  - Export a figure to A4 color PDF format
% 	graphicxFigures/exportj                  - Export a figure to A4 color PNG format
% 	graphicxFigures/exportp                  - Export a figure to A4 color PDF format
% 	graphicxFigures/exports                  - Export a figure to A4 color PDF format
% 	graphicxFigures/expt                     - Export a figure to pdf format in a temporary folder/file
% 	graphicxFigures/figs2pdf                 - Save several figures in 1 pdf file
% 	graphicxFigures/figur                    - FIGUR Create figure window without Menu Bar
% 	graphicxFigures/figure_land              - White background landscape figure
% 	graphicxFigures/figure_setcolor          - Change background color of a set of figures
% 	graphicxFigures/figure_tall              - White background portrait figure
% 	graphicxFigures/figures2htm              - Writes all open figures to .png files and integrates them in a html file
% 	graphicxFigures/fnote                    - Add a text note box to a figure
% 	graphicxFigures/footnote                 - Add a footnote to a plot
% 	graphicxFigures/footstamp                - Create the default footnote for figure
% 	graphicxFigures/graphtool                - Custom graphic toolbar for figure
% 	graphicxFigures/hidemenu                 - Hide the menubar of a figure
% 	graphicxFigures/load_icons               - Load CDdata of an predefined icon
% 	graphicxFigures/mailtool                 - Email button to figure toolbar
% 	graphicxFigures/maxi                     - Maximize figure size
% 	graphicxFigures/maximizeplots            - H1LINE
% 	graphicxFigures/mini                     - Reduce figure size to a mini standard
% 	graphicxFigures/mytoolbar                - Add my personnal buttons to the figure toolbar
% 	graphicxFigures/newfig                   - Open a new figure
% 	graphicxFigures/pllist_gui               - H1LINE
% 	graphicxFigures/realgnfootnote           - H1LINE
% 	graphicxFigures/reexportp                - Re-export a figure in pdf using app datas
% 	graphicxFigures/sgetool                  - Add a button to a figure toolbar to check on SGE scripts in the queue
% 	graphicxFigures/showmenu                 - Ensure the menu bar is shown on a figure
% 	graphicxFigures/tall                     - Increase figure size to a large portrait format
% 	graphicxFigures/testicon                 - H1LINE
% 	graphicxFigures/utiltool                 - Create a standalone toolbar with my personnal buttons
% 	graphicxFigures/videotimeline            - Add a video timeline to a plot
% 
% Files in: graphicxPlots/
% 	graphicxPlots/addarrows                  - Add arrows along a contour handle
% 	graphicxPlots/boldnul                    - Make null contours line style dashed
% 	graphicxPlots/cleancont                  - Update color for m_contourf plots
% 	graphicxPlots/cs2st                      - Transform contour matrix into output from streamline
% 	graphicxPlots/dashneg                    - Make dashed negative contours
% 	graphicxPlots/drawbox                    - Draw a rectangular box
% 	graphicxPlots/fitgauss                   - Fit a Gaussian to a distribution plot
% 	graphicxPlots/floatAxisY                 - create floating x-axis for multi-parameter plot
% 	graphicxPlots/floatAxisY_right           - floatAxisY create floating x-axis for multi-parameter plot
% 	graphicxPlots/hline                      - Draw a horizontal line on a plot
% 	graphicxPlots/mapclean                   - Uniform plots and colorbars
% 	graphicxPlots/move_axis                  - Move an axis
% 	graphicxPlots/outerbox                   - Plot a box around a plot
% 	graphicxPlots/patcharrow                 - Create a polygon with an arrow for annotation
% 	graphicxPlots/ptable                     - Creates non uniform subplot handles
% 	graphicxPlots/sublist                    - Subplot indices for portrait/landscape 2 ranks loops plot
% 	graphicxPlots/suptitle                   - Puts a title above all subplots.
% 	graphicxPlots/thematrix                  - Animate a 3D plot by rotating around
% 	graphicxPlots/twodcumsum                 - Plot a 2D field together with its cumsum in both directions
% 	graphicxPlots/twodmean                   - Plot a 2D field together with its means in both directions
% 	graphicxPlots/unifx                      - Uniforms y-axis limits on different figures
% 	graphicxPlots/unify                      - Uniforms y-axis limits on different figures
% 	graphicxPlots/vline                      - Draw a vertical line on a plot
% 	graphicxPlots/xanom                      - Make x-axis centered around 0
% 	graphicxPlots/yanom                      - Make y-axis centered around 0
% 
% Files in: inout/
% 	inout/abspath                            - Relative to Absolute path function
% 	inout/base64encode                       - Perform base64 encoding on a string.
% 	inout/diag_screen                        - Same as DISP but allow to print in a log file
% 	inout/dirr                               - Lists all files in the current directory and sub directories recursively.
% 	inout/file_list                          - Create a file list from a folder
% 	inout/finish                             - Terminate a Matlab session
% 	inout/fmv                                - System command move on a file
% 	inout/fopenn                             - Open a file whithout taking care of slash in file name
% 	inout/fstrrep                            - Replace string with another into a text file
% 	inout/get_plotlist                       - Return description of diagnostic/plot files
% 	inout/get_plotlistdef                    - Display/return description of diagnostic files
% 	inout/get_plotlistfields                 - Returns the list of fields required by a diag
% 	inout/getcomputername                    - returns the name of the computer (hostname)
% 	inout/getip                              - Return the computer network IP address
% 	inout/gmat                               - Grep a string into comments of Matlab routines within a given folder or file
% 	inout/grep                               - Grep a string into definitions of functions
% 	inout/growl                              - Send a notification to Growl
% 	inout/helptocxml2html                    - H1LINE
% 	inout/ltp                                - List directory as ls -rtl
% 	inout/ltx_dlist                          - Copy a LaTeX file TeX ressources to a local folder
% 	inout/ltx_tbll                           - Print a LaTeX table line
% 	inout/ltx_tblo                           - Print opening LaTeX table lines
% 	inout/machine_list                       - List all network machine with system command 'nslookup'
% 	inout/mailsend                           - Send an email via the system command 'mail'
% 	inout/myqst                              - Display qstat results
% 	inout/nlines                             - Number of lines in a text file
% 	inout/nojvmwaitbar                       - Progress waitbar for Matlab running without JVM
% 	inout/packver                            - Manage Package Version file
% 	inout/plgrep                             - Grep a string into definitions of sub plots/diagnostics
% 	inout/pllist                             - Shortcut for function get_plotlistdef(MASTER,'.')
% 	inout/qstat                              - Return command qstat -u user outputs
% 	inout/remindme                           - Reminder using crontab and growl
% 	inout/serveraddress                      - Display nslookup output
% 	inout/strins                             - Insert a string into another
% 	inout/tbcont                             - Audit a directory and create html/wiki pages and table of content
% 	inout/url_code                           - Percent encode/decode of a string
% 	inout/wsload                             - Load all (or list of) variables of the base workspace into a function workspace
% 	inout/wssave                             - Save all (or list of) variables from the caller workspace into the base workspace
% 	inout/wssize                             - H1LINE
% 
% Files in: matrix/
% 	matrix/assym                             - Compute sym. or assym. component of 2D field
% 	matrix/curvearea                         - Compute curve area in a crude way
% 	matrix/dim                               - Give the number of dimensions of a field
% 	matrix/dispt                             - Display a table on prompt
% 	matrix/duplicate                         - Find duplicate values among a 1D table
% 	matrix/findp                             - Find the p power of 10 of a number
% 	matrix/iseven                            - True for even array
% 	matrix/m2cols                            - Transform a 1 dimensional matrix to a square one with elements on columns
% 	matrix/m2diag                            - Transform a 1 dimensional matrix to a square one with elements on the diagonal
% 	matrix/monthlabs                         - Get various labels of months
% 	matrix/mywkeep                           - Keep part of a vector or a matrix.
% 	matrix/nansummap                         - Multidimensional nansum
% 	matrix/rotatepolygon                     - H1LINE
% 	matrix/smoother1Ddiff                    - Apply a diffusive smoother on a 1D field
% 	matrix/smoother2Ddiff                    - Apply a diffusive smoother on a 2D field
% 
% Files in: mcentral/
% 	mcentral/gtrack                          - Track mouse position and show coordinates in figure title.
% 	mcentral/hindex                          - Computes the h-index of an author from Google Scholar.
% 	mcentral/hypsometry                      - Hypsometric Integral
% 	mcentral/popd                            - Pops you back up in the PUSHD stack
% 	mcentral/ps2pdf                          - Function to convert a PostScript file to PDF using Ghostscript
% 	mcentral/pushd                           - Changes MATLAB working directory to the one specified, or to the folder containing the specified file
% 	mcentral/usercolormap                    - Create a color map.
% 	mcentral/winsinc                         - Applies a windowed sinc filter
% 	mcentral/xticklabel_rotate               - hText = xticklabel_rotate(XTick,rot,XTickLabel,varargin) Rotate XTickLabel
% 
% Files in: netcdf/
% 	netcdf/ncdimname                         - List dimensions name of a netcdf object
% 	netcdf/ncvardesc                         - List informations about variables of a netcdf object
% 	netcdf/ncvarlongname                     - List variables long name of a netcdf object
% 	netcdf/ncvarname                         - List variable name of a netcdf object
% 
% Files in: off/
% 	off/colorbar2                            - Display color bar (color scale).
% 	off/colorbar3                            - when this is done doing whatever it does
% 	off/colorbar_off                         - Display color bar (color scale).
% 	off/getP                                 - Determine la puissance de 10 d'un nombre
% 	off/log2jobid                            - H1LINE MISSING
% 	off/mapanom2                             - H1LINE MISSING
% 
% Files in: overwrite/
% 	overwrite/clf                            - Clear current figure
% 	overwrite/corrcoef                       - Correlation coefficients.
% 	overwrite/dashline                       - Function to produce accurate dotted and dashed lines
% 	overwrite/fftmspec                       - Module Spectra of the Fourier Transform
% 	overwrite/figure                         - Create customized figure window
% 	overwrite/fitfun                         - Used by FITDEMO.
% 	overwrite/ginput                         - Graphical input from mouse.
% 	overwrite/refline                        - Add a reference line to a plot.
% 	overwrite/refresh                        - Refresh figure
% 	overwrite/system                         - H1LINE
% 	overwrite/title                          - Custom Graph title
% 
% Files in: statistics/
% 	statistics/WSEdecomp                     - Split a signal into its downward/upward propagating and stationnary components
% 	statistics/allstats                      - STATM Compute statistics from 2 series
% 	statistics/armodel2                      - Two Dimensional Spectral Estimation
% 	statistics/chi2conf                      - Confidence interval using inverse of chi-square cdf.
% 	statistics/gauss                         - Gaussian function
% 	statistics/getcrosscor                   - Compute a lagged cross-correlation
% 	statistics/getdblpeaks                   - Find indices corresponding to a common peak in two series
% 	statistics/getpeaks                      - Determine peak(s) of function X
% 	statistics/getscatter                    - Get scatter plot distribution
% 	statistics/hannfilter                    - Disable function
% 	statistics/lanczos                       - Filtre de lanczos
% 	statistics/lanfilt                       - High, low, band pass filters based on Lanczos filter
% 	statistics/linvp                         - Linear inverse problem
% 	statistics/lisse                         - Smooth a scalar array with a running mean
% 	statistics/mcovar2                       - Two Dimensioal Spectral Estimation
% 	statistics/mynanmean                     - Average or mean value of matrix with NaN.
% 	statistics/mypsd2                        - Power Spectral Density estimate.
% 	statistics/mypsdchk                      - Helper function for PSD, CSD, COHERE, and TFE.
% 	statistics/myrunmean                     - Perform running mean on an array
% 	statistics/myspecgram                    - Spectrogram
% 	statistics/nlinvp                        - Non-Linear inverse problem
% 	statistics/periodogram2                  - Computes the 2-D periodogram based on Fourier Method
% 	statistics/taylordiag                    - Plot a Taylor Diagram
% 	statistics/trend                         - Find a linear trend from a vector, usually for FFT processing.
% 	statistics/wmean                         - Compute a weighted mean
% 	statistics/wstd                          - Compute a weighted standard deviation
% 	statistics/xtrm                          - Find the extreme value of a 2D field (either positive or negative)
% 
% This Contents.m file was automatically created using: /Users/gmaze/matlab/codes/inout/tbcont
% 
