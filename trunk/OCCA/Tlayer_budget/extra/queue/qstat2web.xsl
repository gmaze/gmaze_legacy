<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/job_info">
<html>
<head>
<title>SGE qstat</title>
<link rel="stylesheet" href="qstat2web.css" type="text/css"/>
</head>


<body background="#000">

<table cellspacing="10" border="0">
<tr><td align="left" valign="top">

<!-- Running -->
<h1>Running</h1>
<table border="1" cellpadding="4" cellspacing="0">
<tr>
<th>Queue Name</th>
<th>Job ID</th>
<th>Job Name</th>
<th>Task ID</th>
<th>State</th>
<th>Start Time</th>
</tr>
<xsl:for-each select="queue_info/Queue-List">
<tr>
<td class="value"><xsl:value-of select="name/text()" /></td>
<td class="value"><xsl:value-of select="job_list/JB_job_number/text()" /></td>
<td class="value"><xsl:value-of select="job_list/JB_name/text()" /></td>
<td class="value"><xsl:value-of select="job_list/tasks/text()" /></td>
<td class="value"><span class="running"><xsl:value-of select="job_list/@state" /></span></td>
<td class="value"><xsl:value-of select="job_list/JAT_start_time/text()" /></td>
</tr>
</xsl:for-each>
</table>


</td>
<td align="left" valign="top">


<!-- Pending -->
<h1>Pending</h1>
<table border="1" cellpadding="4" cellspacing="0">
<tr>
<th>Job ID</th>
<th>Job Name</th>
<th>Task ID</th>
<th>State</th>
<th>Submission Time</th>
</tr>
<xsl:for-each select="job_info/job_list">
<tr>
<td class="value"><xsl:value-of select="JB_job_number/text()" /></td>
<td class="value"><xsl:value-of select="JB_name/text()" /></td>
<td class="value"><xsl:value-of select="tasks/text()" /></td>
<td class="value"><span class="pending"><xsl:value-of select="@state" /></span></td>
<td class="value"><xsl:value-of select="JB_submission_time/text()" /></td>
</tr>
</xsl:for-each>
</table>

</td>
</tr>
</table>


</body>
</html>
</xsl:template>
</xsl:stylesheet>
