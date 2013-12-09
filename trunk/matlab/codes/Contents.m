% Guillaume Maze: Codes for Matlab
% Version 1 1 04-Mar-2011
% 
% 		Contents from /Users/gmaze/matlab/codes
% 
% Last update: 2013 December 09, 15:15
% 
% Files in: colors/
% 	colors/bluewhitered                      - Blue, white, and red color map.
% 	colors/canom                             - Center the caxis on zero
% 	colors/clabelcmap                        - Create labels for colorbar
% 	colors/cmapa                             - change colormap for anomalies
% 	colors/cmaptwo                           - Join two colormaps
% 	colors/colormap                          - Color look-up table.
% 	colors/colormap_cpt                      - builds a matlab colormap from a cpt file
% 	colors/colormap_plt                      - Load a colormap from the Matplotlib palette
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
% Files in: geophysic/
% 	geophysic/WOA05_grid                     - Read World Ocean Atlas 2005 grid
% 	geophysic/compute_air_sea_o2_flux        - Compute air-sea oxygen flux
% 	geophysic/constraint_jstar               - H1LINE
% 	geophysic/convX                          - Convert longitude convention
% 	geophysic/convert_oxygen                 - O2 unit conversion
% 	geophysic/convert_unit                   - Convert unit of oceanic concentration substance
% 	geophysic/csvreadargo                    - H1LINE
% 	geophysic/csvreadargo2                   - H1LINE
% 	geophysic/densjmd95                      - Density of sea water
% 	geophysic/dfromo                         - Compute distances of points from an origin
% 	geophysic/diagCatH                       - Compute a 3D field projection on a 2D surface
% 	geophysic/diagHatisoC                    - Compute iso-surface of a 3D field
% 	geophysic/diag_PV                        - PV = diag_PV(LON,LAT,DPT,SIGMATHETA,RHO)
% 	geophysic/diag_interpallREQ              - NEWFIELD = diag_interpallREQ(FIELD,LON,LAT,netcdf_domain,resolution,...
% 	geophysic/dinterp3bin                    - Interpolate a 3D field
% 	geophysic/dinterp3bin_grid               - Compute the new grid for DINTERP3BIN interpolated fields
% 	geophysic/distsphere                     - Compute the angle between two points on the sphere
% 	geophysic/dlowerres                      - Reduce the resolution of a field
% 	geophysic/drawmpoly                      - drawpoly Draw a polygon on a map (using m_map)
% 	geophysic/dwn_nao                        - Download the monthly NAO index
% 	geophysic/fillgaps                       - Try to fill gaps in 2D geograpical field
% 	geophysic/getGRD                         - Compute horizontal gradient of a geographical field
% 	geophysic/get_elev_along_track           - elev_along_track Determine topograpahy along ship track
% 	geophysic/get_mld                        - Compute a mixed layer depth
% 	geophysic/get_mmld_along_track           - Get Boyer-Montegut MLD climatology along a track
% 	geophysic/get_occaclim_along_track       - get_occa_along_track H1LINE
% 	geophysic/get_ovide_track                - Load OVIDE track
% 	geophysic/get_pyc                        - Compute pycnocline characteristics
% 	geophysic/get_pyc_idvgrads_v2            - Identify profile properties based on N2
% 	geophysic/get_pyc_idvgrads_v2b           - Identify profile properties based on N2
% 	geophysic/get_thd                        - Determine the seasonal and main thermocline depths
% 	geophysic/get_thdv2                      - H1LINE
% 	geophysic/get_woa_along_track            - Interpolate World Ocean Atlas data along a ship track
% 	geophysic/getdH                          - Compute Layer thickness from a vertical axis
% 	geophysic/getdS                          - Compute 2D surface elements matrix
% 	geophysic/getdV                          - Compute 3D volume elements matrix
% 	geophysic/guiOCCA                        - GUI to OCCA dataset
% 	geophysic/is_in_box                      - Identify points inside a geographical domain or box
% 	geophysic/lldist                         - Compute distance in m between two points on Earth
% 	geophysic/load_climOCCA                  - Load any climatological fields from OCCA
% 	geophysic/load_maskOCCA                  - Load any mask from OCCA
% 	geophysic/m_drawbox                      - Draw a rectangular box using m_line
% 	geophysic/oc_vmodes                      - Compute vertical mode solutions
% 	geophysic/piston_velocity                - Compute a gaz air-sea interface transfer velocity (piston velocity)
% 	geophysic/plotts                         - Plot Temperature, Salinity on a T,S diag
% 	geophysic/project3don2d                  - Project a 3D field on a 2D surface
% 	geophysic/scalprod                       - Cross or dot product of two 3D scalar fields
% 	geophysic/schmidt_number                 - Compute a Schmidt number
% 	geophysic/select_1transect               - Extract only one transect from a campaign
% 	geophysic/simplify_unit                  - Simplify unit expression
% 	geophysic/typicalyear                    - Compute a typical year from a daily volume time serie
% 	geophysic/udunits                        - Unidata units library
% 
% Files in: graphicxFigures/
% 	graphicxFigures/algnfootnote             - Horizontal alignement of the footnote for export
% 	graphicxFigures/command2fig              - Print on a figure the command window output of one variable
% 	graphicxFigures/export                   - Export a figure to A4 color EPS format
% 	graphicxFigures/exportf                  - Export a figure to A4 color PDF format
% 	graphicxFigures/exportj                  - Export a figure to A4 color PNG format
% 	graphicxFigures/exportp                  - Export a figure to A4 color PDF format
% 	graphicxFigures/exports                  - Export a figure to A4 color PDF format
% 	graphicxFigures/expt                     - Export a figure to pdf format in a temporary folder/file
% 	graphicxFigures/ffband                   - White background thin landscape figure
% 	graphicxFigures/ffland                   - Open a new figure with landscape orientation
% 	graphicxFigures/fftall                   - Open a new figure with portrait orientation
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
% 	graphicxFigures/stickynote               - H1LINE
% 	graphicxFigures/tall                     - Increase figure size to a large portrait format
% 	graphicxFigures/testicon                 - H1LINE
% 	graphicxFigures/utiltool                 - Create a standalone toolbar with my personnal buttons
% 	graphicxFigures/videotimeline            - Add a video timeline to a plot
% 
% Files in: graphicxPlots/
% 	graphicxPlots/addarrows                  - Add arrows along a contour handle
% 	graphicxPlots/ahline                     - Draw a horizontal line on a plot and print value on the y-axis
% 	graphicxPlots/boldnul                    - Make null contours line style dashed
% 	graphicxPlots/cleancont                  - Update color for m_contourf plots
% 	graphicxPlots/cs2st                      - Transform contour matrix into output from streamline
% 	graphicxPlots/dashneg                    - Make dashed negative contours
% 	graphicxPlots/drawbox                    - Draw a rectangular box
% 	graphicxPlots/fitgauss                   - Fit a Gaussian to a distribution plot
% 	graphicxPlots/floatAxisY                 - create floating x-axis for multi-parameter plot
% 	graphicxPlots/floatAxisY_right           - floatAxisY create floating x-axis for multi-parameter plot
% 	graphicxPlots/hline                      - Draw a horizontal line on a plot
% 	graphicxPlots/linerr                     - Plot a line whose thickness represents error bars (using patch)
% 	graphicxPlots/mapclean                   - Uniform plots and colorbars
% 	graphicxPlots/move_axes                  - Move an axis (plot) within a figure
% 	graphicxPlots/outerbox                   - Plot a box around a plot
% 	graphicxPlots/patcharrow                 - Create a polygon with an arrow for annotation
% 	graphicxPlots/ptable                     - Creates non uniform subplot handles
% 	graphicxPlots/sublist                    - Subplot indices for portrait/landscape 2 ranks loops plot
% 	graphicxPlots/suptitle                   - Puts a title above all subplots.
% 	graphicxPlots/thematrix                  - Animate a 3D plot by rotating around
% 	graphicxPlots/twodcumsum                 - Plot a 2D field together with its cumsum in both directions
% 	graphicxPlots/twodmean                   - Plot a 2D field together with its means in both directions
% 	graphicxPlots/unifx                      - Uniforms x-axis limits on different figures
% 	graphicxPlots/unify                      - Uniforms y-axis limits on different figures
% 	graphicxPlots/vline                      - Draw a vertical line on a plot
% 	graphicxPlots/xanom                      - Make x-axis centered around 0
% 	graphicxPlots/yanom                      - Make y-axis centered around 0
% 
% Files in: inout/
% 	inout/abspath                            - Relative to Absolute path function
% 	inout/base64encode                       - Perform base64 encoding on a string.
% 	inout/diag_screen                        - Same as DISP but allow to print in a log file
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
% 	inout/h1line                             - Search for text in h1 lines
% 	inout/helptocxml2html                    - H1LINE
% 	inout/jvmwaitbar                         - Progress wait bar for Matlab running with Java on console
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
% 	inout/readh1line                         - Read the H1 line of a matlab script file
% 	inout/remindme                           - Reminder using crontab and growl
% 	inout/sep                                - Draw/Create a horizontal line on the terminal
% 	inout/serveraddress                      - Display nslookup output
% 	inout/stralign                           - Align/Justify a string within a given sized blank space
% 	inout/strins                             - Insert a string into another
% 	inout/tbcont                             - Audit a directory and create html/wiki pages and table of content
% 	inout/tweet                              - Send tweets !
% 	inout/url_code                           - Percent encode/decode of a string
% 	inout/wsload                             - Load all (or list of) variables of the base workspace into a function workspace
% 	inout/wssave                             - Save all (or list of) variables from the caller workspace into the base workspace
% 	inout/wssize                             - H1LINE
% 
% Files in: matrix/
% 	matrix/assym                             - Compute sym. or assym. component of 2D field
% 	matrix/curvearea                         - Compute curve area in a crude way
% 	matrix/datenumserie                      - Create a time serie with datenum
% 	matrix/diag_error                        - Propagate error estimates for misc operators
% 	matrix/dim                               - Give the number of dimensions of a field
% 	matrix/dispt                             - Display a table on prompt
% 	matrix/duplicate                         - Find duplicate values among a 1D table
% 	matrix/findp                             - Find the p power of 10 of a number
% 	matrix/iseven                            - True for even array
% 	matrix/isin                              - Check if a table contains values of another table
% 	matrix/m2cols                            - Transform a 1 dimensional matrix to a square one with elements on columns
% 	matrix/m2diag                            - Transform a 1 dimensional matrix to a square one with elements on the diagonal
% 	matrix/monthlabs                         - Get various labels of months
% 	matrix/mywkeep                           - Keep part of a vector or a matrix.
% 	matrix/nansummap                         - Multidimensional nansum
% 	matrix/rgb2web                           - Convert an rgb colormap map to a javascript array of webcolor strings.
% 	matrix/rotatepolygon                     - H1LINE
% 	matrix/smoother1Ddiff                    - Apply a diffusive smoother on a 1D field
% 	matrix/smoother2Ddiff                    - Apply a diffusive smoother on a 2D field
% 
% Files in: mcentral/
% 	mcentral/ConsoleProgressBar              - Console progress bar for long-running operations
% 	mcentral/barwitherr                      - Make a bar plot with errors
% 	mcentral/bin2mat                         - - create a 2D matrix from scattered data without interpolation
% 	mcentral/clusterData                     - Clusters an MxN array of data into an unspecified number (P) of bins.
% 	mcentral/datevec2doy                     - Takes a date vector and returns the day of year, known incorrectly in the
% 	mcentral/dirr                            - Lists all files in the current directory and sub directories recursively.
% 	mcentral/dragdemo                        - Demo for the draggable.m
% 	mcentral/draggable                       - - Make it so that a graphics object can be dragged in a figure.
% 	mcentral/gtrack                          - Track mouse position and show coordinates in figure title.
% 	mcentral/hindex                          - Computes the h-index of an author from Google Scholar.
% 	mcentral/hypsometry                      - Hypsometric Integral
% 	mcentral/julian2greg                     - This function converts the Julian dates to Gregorian dates.
% 	mcentral/kriging                         - Interpolation with ordinary kriging in two dimensions
% 	mcentral/nanmax                          - Maximum value, ignoring NaNs.
% 	mcentral/nanmean                         - Mean value, ignoring NaNs.
% 	mcentral/nanmedian                       - Median value, ignoring NaNs.
% 	mcentral/nanmin                          - Minimum value, ignoring NaNs.
% 	mcentral/nanstd                          - Standard deviation, ignoring NaNs.
% 	mcentral/nansum                          - Sum, ignoring NaNs.
% 	mcentral/nanvar                          - Variance, ignoring NaNs.
% 	mcentral/outliers                        - function: Remove outliers based on Thompson Tau:
% 	mcentral/ploterr                         - General error bar plot.
% 	mcentral/popd                            - Pops you back up in the PUSHD stack
% 	mcentral/prctile                         - Percentiles of a sample.
% 	mcentral/ps2pdf                          - Function to convert a PostScript file to PDF using Ghostscript
% 	mcentral/pushd                           - Changes MATLAB working directory to the one specified, or to the folder containing the specified file
% 	mcentral/pwr_kml                         - makes a kml file for use in google earth
% 	mcentral/removeoutliers                  - Remove outliers from data using the Thompson Tau method.
% 	mcentral/rgbconv                         - Convert hex color to or from matlab rgb vector.
% 	mcentral/sinefit                         - params = sinefit(yin,t,f)
% 	mcentral/stretchcolormap                 - STRETCHCOLOR stretch the colormap
% 	mcentral/sw_vmodes                       - calculate vertical modes in a flat-bottomed ocean.
% 	mcentral/usercolormap                    - Create a color map.
% 	mcentral/variogramfit                    - Fit a theoretical variogram to an experimental variogram
% 	mcentral/winsinc                         - Applies a windowed sinc filter
% 	mcentral/xticklabel_rotate               - hText = xticklabel_rotate(XTick,rot,XTickLabel,varargin) Rotate XTickLabel
% 
% Files in: netcdf/
% 	netcdf/ncbuiltin                         - Is this Matlab using built-in netcdf or not ?
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
% 	overwrite/system                         - Fix issue with missing .cshrc
% 	overwrite/title                          - Custom Graph title
% 
% Files in: statistics/
% 	statistics/WSEdecomp                     - Split a signal into its downward/upward propagating and stationnary components
% 	statistics/allstats                      - STATM Compute statistics from 2 series
% 	statistics/armodel2                      - Two Dimensional Spectral Estimation
% 	statistics/benchthis                     - Benchmark an expression or function call (performace)
% 	statistics/bin1mat                       - create a 1D matrix from scattered data without interpolation
% 	statistics/chi2conf                      - Confidence interval using inverse of chi-square cdf.
% 	statistics/comp2ts                       - Plot a serie of graphes to compare two time series (scatter, crosscor)
% 	statistics/fitbest                       - Determine the best least-square curve fitting solution
% 	statistics/fitlin                        - Linear least-square curve fitting
% 	statistics/fitlog                        - Logarithmic least-square curve fitting
% 	statistics/fitpow                        - Power Law least-square curve fitting
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
% 	statistics/scat2mat                      - Map scattered data onto a regular grid
% 	statistics/smartchunk                    - Compute homogeneous chunks of data
% 	statistics/stan                          - Return a standardized serie
% 	statistics/taylordiag                    - Plot a Taylor Diagram
% 	statistics/trend                         - Find a linear trend from a vector, usually for FFT processing.
% 	statistics/wmean                         - Compute a weighted mean
% 	statistics/wstd                          - Compute a weighted standard deviation
% 	statistics/xtrm                          - Find the extreme value of a 2D field (either positive or negative)
% 
% Files in: veryprivate/
% 	veryprivate/bibus                        - Give me the next bus
% 	veryprivate/blk                          - Insert a blank page at the terminal prompt
% 	veryprivate/cbsnews                      - Open the CBS Evening News podcast with your browser
% 	veryprivate/check_ethlog                 - Update and view the my IFREMER working timeline
% 	veryprivate/cw                           - Move to working directory
% 	veryprivate/figure_central               - Returns customized parameters to create a figure
% 	veryprivate/gcontact2maillist            - Removed < and > from a Google contacts list
% 	veryprivate/gfdsearch_bulkupload         - H1LINE
% 	veryprivate/google_reader_to_timeline    - Google reader opml file to be used in Google Timeline
% 	veryprivate/tex2html                     - LaTeX to Html converter for intranet
% 	veryprivate/top                          - Give back informations about the memory use of Matlab
% 	veryprivate/update_codes                 - Update meta informations for my Matlab Codes
% 	veryprivate/wherearewe                   - Give back a string to identify your location
% 
% This Contents.m file was automatically created using: /Users/gmaze/matlab/codes/inout/tbcont
% 
