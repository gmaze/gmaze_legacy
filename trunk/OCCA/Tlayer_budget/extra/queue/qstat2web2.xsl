<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/job_info">
<html>
<head>
<title>SGE qstat</title>
<link rel="stylesheet" href="qstat2web2.css" type="text/css"/>
</head>

<body background="#fff">

<table border="0" cellpadding="4" cellspacing="0">
<tr><td colspan="6" bgcolor="#f00"><h1>Active</h1></td></tr>
<tr>
<th>Queue Name</th>
<th>Job ID</th>
<th>Job Name</th>
<th>Task ID</th>
<th>State</th>
<th>Start Time</th>
</tr>
<xsl:for-each select="queue_info/job_list">
<tr>
<td class="value"><xsl:value-of select="queue_name/text()" /></td>
<td class="value"><xsl:value-of select="JB_job_number/text()" /></td>
<td class="value"><xsl:value-of select="JB_name/text()" /></td>
<td class="value"><xsl:value-of select="JB_job_number/text()" /></td>
<td class="value"><span class="running"><xsl:value-of select="@state" /></span></td>
<td class="value"><xsl:value-of select="JAT_start_time/text()" /></td>
</tr>
</xsl:for-each>

<tr><td colspan="6" bgcolor="#f00"><h1>Pending</h1></td></tr>
<tr>
<th>Queue Name</th>
<th>Job ID</th>
<th>Job Name</th>
<th>Task ID</th>
<th>State</th>
<th>Submission Time</th>
</tr>
<xsl:for-each select="job_info/job_list">
<tr>
<td class="value"><xsl:value-of select="queue_name/text()" /></td>
<td class="value"><xsl:value-of select="JB_job_number/text()" /></td>
<td class="value"><xsl:value-of select="JB_name/text()" /></td>
<td class="value"><xsl:value-of select="JB_job_number/text()" /></td>
<td class="value"><span class="pending"><xsl:value-of select="@state" /></span></td>
<td class="value"><xsl:value-of select="JB_submission_time/text()" /></td>
</tr>
</xsl:for-each>
</table>

</body>
</html>
</xsl:template>
</xsl:stylesheet>
