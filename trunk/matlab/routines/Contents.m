% 
% 		Contents from /Users/gmaze/matlab/routines
% 
% Last update: 2010 February 10, 14:45
% 
% 	WOA05_grid                               - Read World Ocean Atlas 2005 grid
% 	WSEdecomp                                - Split a signal into its downward/upward propagating and stationnary components
% 	abspath                                  - Relative to Absolute path function
% 	algnfootnote                             - H1LINE
% 	allstats                                 - STATM Compute statistics from 2 series
% 	armodel2                                 - Two Dimensional Spectral Estimation
% 	assym                                    - Compute sym. or assym. component of 2D field
% 	backup                                   - Backup disk content to some remote directory
% 	base64encode                             - Perform base64 encoding on a string.
% 	bibus                                    - Give me the next bus
% 	cbsnews                                  - Open the CBS Evening News podcast with your browser
% 	check_ethlog                             - Update and view the my IFREMER working timeline
% 	chi2conf                                 - Confidence interval using inverse of chi-square cdf.
% 	cleancont                                - Update color for m_contourf plots
% 	constraint_jstar                         - H1LINE
% 	convert_oxygen                           - O2 unit conversion
% 	convert_unit                             - Convert unit of oceanic concentration substance
% 	corrcoef                                 - Correlation coefficients.
% 	cs2st                                    - Transform contour matrix into output from streamline
% 	csvreadargo                              - H1LINE
% 	csvreadargo2                             - H1LINE
% 	curvearea                                - Compute curve area in a crude way
% 	dashneg                                  - Make dashed negative contours
% 	densjmd95                                - Density of sea water
% 	diagCatH                                 - Compute a 3D field projection on a 2D surface
% 	diagHatisoC                              - Compute iso-surface of a 3D field
% 	diag_PV                                  - PV = diag_PV(LON,LAT,DPT,SIGMATHETA,RHO)
% 	diag_screen                              - Same as DISP but allow to print in a log file
% 	dim                                      - Give the number of dimensions of a field
% 	dinterp3bin                              - Interpolate a 3D field
% 	dinterp3bin_grid                         - Compute the new grid for DINTERP3BIN interpolated fields
% 	dlowerres                                - Reduce the resolution of a field
% 	drawbox                                  - Draw a rectangular box
% 	dwn_nao                                  - Download the monthly NAO index
% 	export                                   - Export a figure to A4 color EPS format
% 	exportf                                  - Export a figure to A4 color PDF format
% 	exportj                                  - Export a figure to A4 color PNG format
% 	exportp                                  - Export a figure to A4 color PDF format
% 	fftmspec                                 - Module Spectra of the Fourier Transform
% 	figur                                    - FIGUR Create figure window without Menu Bar
% 	figure                                   - Create customized figure window
% 	figure_land                              - White background landscape figure
% 	figure_tall                              - White background portrait figure
% 	figures2htm                              - Writes all open figures to .png files and integrates them in a html file
% 	file_list                                - Create a file list from a folder
% 	findp                                    - Find the p power of 10 of a number
% 	fitfun                                   - Used by FITDEMO.
% 	fitgauss                                 - Fit a Gaussian to a distribution plot
% 	footnote                                 - Add a footnote to a plot
% 	footstamp                                - Create the default footnote for figure
% 	fopenn                                   - Open a file whithout taking care of slash in file name
% 	gauss                                    - Gaussian function
% 	gcontact2maillist                        - Removed < and > from a Google contacts list
% 	getGRD                                   - Compute horizontal gradient of a geographical field
% 	get_elev_along_track                     - elev_along_track Determine topogrpahy along ship track
% 	get_mld                                  - Compute the mixed layer depth
% 	get_plotlist                             - Return description of diagnostic/plot files
% 	get_plotlistdef                          - Display/return description of diagnostic files
% 	get_plotlistfields                       - Returns the list of fields required by a diag
% 	get_thd                                  - Determine the seasonal and main thermocline depths
% 	get_woa_along_track                      - Interpolate World Ocean Atlas data along a ship track
% 	getcomputername                          - returns the name of the computer (hostname)
% 	getcrosscor                              - Compute a lagged cross-correlation
% 	getdS                                    - Compute 2D surface elements matrix
% 	getdV                                    - Compute 3D volume elements matrix
% 	getdblpeaks                              - Find indices corresponding to a common peak in two series
% 	getip                                    - Return the computer network IP address
% 	getpeaks                                 - Determine peak(s) of function X
% 	getscatter                               - Get scatter plot distribution
% 	gmat                                     - Grep a string into comments of Matlab routines within a given folder or file
% 	google_reader_to_timeline                - Google reader opml file to be used in Google Timeline
% 	graphtool                                - Custom graphic toolbar for figure
% 	grep                                     - Grep a string into definitions of functions
% 	growl                                    - Send a notification to Growl
% 	guiOCCA                                  - GUI to OCCA dataset
% 	hannfilter                               - Disable function
% 	hidemenu                                 - Hide the menubar of a figure
% 	hypsometry                               - Hypsometric Integral
% 	iseven                                   - True for even array
% 	lanczos                                  - Filtre de lanczos
% 	lanfilt                                  - High, low, band pass filters based on Lanczos filter
% 	lisse                                    - Smooth a scalar array with a running mean
% 	lldist                                   - Compute distance in m between two points on Earth
% 	load_climOCCA                            - Load any climatological fields from OCCA
% 	load_icons                               - Load CDdata of an predefined icon
% 	load_maskOCCA                            - Load any mask from OCCA
% 	logcolormap                              - Stretch a colormap extremum toward black and white
% 	ltp                                      - List directory as ls -rtl
% 	m_drawbox                                - Draw a rectangular box using m_line
% 	machine_list                             - List all network machine with system command 'nslookup'
% 	mailsend                                 - Send an email via the system command 'mail'
% 	mailtool                                 - Email button to figure toolbar
% 	mapclean                                 - Uniform plots and colorbars
% 	maxi                                     - Maximize figure size
% 	mcovar2                                  - Two Dimensioal Spectral Estimation
% 	mini                                     - Reduce figure size to a mini standard
% 	monthlabs                                - Get various labels of months
% 	mycolormap                               - Change colormap resolution
% 	mynanmean                                - Average or mean value of matrix with NaN.
% 	mypsd2                                   - Power Spectral Density estimate.
% 	mypsdchk                                 - Helper function for PSD, CSD, COHERE, and TFE.
% 	myqst                                    - Display qstat results
% 	myqst2                                   - Display qstat results based on xml
% 	myrunmean                                - Perform running mean on an array
% 	myspecgram                               - Spectrogram
% 	mytoolbar                                - Add my personnal buttons to the figure toolbar
% 	mywkeep                                  - Keep part of a vector or a matrix.
% 	ncvardesc                                - List informations about variables of a netcdf object
% 	ncvarlongname                            - List variables long name of a netcdf object
% 	ncvarname                                - List variable name of a netcdf object
% 	newclim                                  - Used to get more than 1 colormap in subplot windows
% 	nlines                                   - Number of lines in a text file
% 	periodogram2                             - Computes the 2-D periodogram based on Fourier Method
% 	plgrep                                   - Grep a string into definitions of sub plots/diagnostics
% 	pllist                                   - Shortcut for function get_plotlistdef(MASTER,'.')
% 	pllist_gui                               - H1LINE
% 	plotts                                   - Plot Temperature, Salinity on a T,S diag
% 	ptable                                   - Creates non uniform subplot handles
% 	qstat                                    - Return command qstat -u user outputs
% 	realgnfootnote                           - H1LINE
% 	refresh                                  - Refresh figure
% 	remindme                                 - Reminder using crontab and growl
% 	scalprod                                 - Cross or dot product of two 3D scalar fields
% 	select_1transect                         - Extract only one transect from a campaign
% 	serveraddress                            - Display nslookup output
% 	setcolormaps                             - Sets the colormap as the union of two at certain level.
% 	sgetool                                  - Add a button to a figure toolbar to check on SGE scripts in the queue
% 	showmenu                                 - Ensure the menu bar is shown on a figure
% 	smoother1Ddiff                           - Apply a diffusive smoother on a 1D field
% 	smoother2Ddiff                           - Apply a diffusive smoother on a 2D field
% 	strins                                   - Insert a string into another
% 	sublist                                  - Subplot indices for portrait/landscape 2 ranks loops plot
% 	suptitle                                 - Puts a title above all subplots.
% 	tall                                     - Increase figure size to a large portrait format
% 	taylordiag                               - Plot a Taylor Diagram
% 	tbcont                                   - Audit a directory and create html/wiki pages and table of content
% 	tex2html                                 - LaTeX to Html converter for intranet
% 	thematrix                                - Animate a 3D plot by rotating around
% 	thincolorbar                             - Display thinner colorbar
% 	top                                      - Give back informations about the memory use of Matlab
% 	trend                                    - Find a linear trend from a vector, usually for FFT processing.
% 	twodcumsum                               - Plot a 2D field together with its cumsum in both directions
% 	twodmean                                 - Plot a 2D field together with its means in both directions
% 	typicalyear                              - Compute a typical year from a daily volume time serie
% 	udunits                                  - Unidata units library
% 	unif                                     - Uniformize colorscale on different figures
% 	unifx                                    - Uniforms y-axis limits on different figures
% 	unify                                    - Uniforms y-axis limits on different figures
% 	url_code                                 - Percent encode/decode of a string
% 	usercolormap                             - Create a color map.
% 	utiltool                                 - Create a standalone toolbar with my personnal buttons
% 	videotimeline                            - Add a video timeline to a plot
% 	wherearewe                               - Give back a string to identify your location
% 	winsinc                                  - Applies a windowed sinc filter
% 	wsload                                   - Load all (or list of) variables of the base workspace into a function workspace
% 	wssave                                   - Save all (or list of) variables from the caller workspace into the base workspace
% 	wssize                                   - H1LINE
% 	xtrm                                     - Find the extreme value of a 2D field (either positive or negative)
% 
% Files in: colormaps/
% 	colormaps/bluewhitered                   - Blue, white, and red color map.
% 	colormaps/canom                          - Center the caxis on zero
% 	colormaps/clabelcmap                     - Create labels for colorbar
% 	colormaps/cmapa                          - H1LINE
% 	colormaps/cseason                        - Colormap for seasons
% 	colormaps/ctitle                         - Display Colorbar title.
% 	colormaps/logcolormap                    - Stretch a colormap extremum toward black and white
% 	colormaps/mycolormaps_create             - H1LINE
% 	colormaps/test_vivid                     - M-file for test_vivid.fig
% 	colormaps/vivid                          - Creates a Personalized Vivid Colormap
% 	colormaps/vivid_contrast                 - H1LINE
% 
% Files in: off/
% 	off/colorbar2                            - Display color bar (color scale).
% 	off/colorbar3                            - when this is done doing whatever it does
% 	off/colorbar_off                         - Display color bar (color scale).
% 	off/getP                                 - Determine la puissance de 10 d'un nombre
% 	off/log2jobid                            - H1LINE MISSING
% 	off/mapanom2                             - H1LINE MISSING
% 
% This Contents.m file was created with /Users/gmaze/matlab/routines/tbcont
% 
