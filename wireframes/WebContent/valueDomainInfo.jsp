<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>

<sj:div cssClass="result ui-widget-content ui-corner-all">
	<table width="100%">
		<col width="4%">
		<col width="96%">

		<tr height="25" valign="bottom">
			<td align=right><font color="#FF0000"> * &nbsp;&nbsp; </font> 1
				)</td>
			<td colspan=4>Context</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td height="26"><select name="selContext" size="1">
					<option value="D9344734-8CAF-4378-E034-0003BA12F5E7">
						caBIG</option>
			</select>
			</td>
		</tr>


		<tr height="25" valign="bottom">

			<td align="right"><font color="#FF0000"> * &nbsp;&nbsp; </font>
				2 )</td>
			<td><font color="#FF0000"> Select </font> Value Domain Type</td>

		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><select name="listVDType" size="1" style="width: 150"
				onChange="ToggleDisableList2();"
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selVDType',helpUrl); return false">
					<option value="E" selected>Enumerated</option>
					<option value="N">Non-Enumerated</option>
			</select>
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right><font color="#FF0000"> * &nbsp;&nbsp; </font> 3
				)</td>
			<td><font color="#FF0000"> Select </font> Value Domain
				Representation</td>
		</tr>
		<tr valign="bottom">
			<td colspan="2">
				<table border="0" width="75%">
					<col width="3%">
					<col width="55%">
					<tr valign="top">
						<td>&nbsp;</td>
						<!-- empty column to seperate componenets -->
						<!-- represention block -->
						<td>
							<table border="1" width="100%">
								<tr valign="top">
									<td>
										<table border="0" width="99%">
											<col width="26%">
											<col width="10%">
											<col width="14%">
											<col width="26%">
											<col width="10%">
											<col width="14%">
											<tr height="30" valign="middle">
												<td colspan=4>Value Domain Attributes</td>
											</tr>
											<tr>
												<td colspan="2" align="left" valign="top">Rep Term Long
													Name</td>
											</tr>
											<tr>
												<td colspan="5" align="left"><input type="text"
													name="txtRepTerm" value="Name" style="width: 100%"
													valign="top" readonly="readonly">
												</td>
											</tr>
											<tr height="8">
												<td></td>
											</tr>
											<tr valign="bottom">
												<td align="left" valign="top">Qualifier Concepts</td>
												<td align="right" valign="middle"><font color="#FF0000">
														<a
														href="javascript:SearchBuildingBlocks('RepQualifier', 'false')">
															Search </a> </font>
												</td>
												<td align="center" valign="middle"><font
													color="#FF0000"> <a
														href="javascript:RemoveBuildingBlocks('RepQualifier')">
															Remove </a> </font>
												</td>
												<td align="left" valign="top">Primary Concept</td>
												<td align="right" valign="middle"><font color="#FF0000">
														<a
														href="javascript:SearchBuildingBlocks('RepTerm', 'false')">
															Search </a> </font>
												</td>
												<td align="center" valign="middle"><font
													color="#FF0000"> <a
														href="javascript:RemoveBuildingBlocks('RepTerm')">
															Remove </a> </font>
												</td>
											</tr>
											<tr align="left">
												<td colspan="3" valign="top"><select
													name="selRepQualifier" size="2" style="width: 98%"
													valign="top" onClick="ShowEVSInfo('RepQualifier')"
													onHelp="showHelp('html/Help_CreateVD.html#createVDForm_nameBlocks',helpUrl); return false">

														<option value=""></option>

												</select>
												</td>

												<td colspan="3" valign="top"><select name="selRepTerm"
													style="width: 98%" valign="top" size="1" multiple
													onHelp="showHelp('html/Help_CreateVD.html#createVDForm_nameBlocks',helpUrl); return false">
														<option value="Name">Name</option>
												</select>
												</td>
											</tr>
											<tr>
												<td colspan="3">&nbsp;&nbsp; <label id="RepQual"
													for="selRepQualifier" title=""></label>
												</td>
												<td colspan="3">&nbsp;&nbsp; <label id="RepTerm"
													for="selRepTerm" title=""></label>
												</td>
											</tr>
											<tr>
												<td colspan="3">&nbsp;&nbsp; <a
													href="javascript:disabled();"> <label id="RepQualID"
														for="selRepQualifier" title=""
														onclick="javascript:SearchBuildingBlocks('RepQualifier', 'true');"/>
												</a>
												</td>
												<td colspan="3">&nbsp;&nbsp; <a
													href="javascript:disabled();"> <label id="RepTermID"
														for="selRepTerm" title=""
														onclick="javascript:SearchBuildingBlocks('RepTerm', 'true');"/>
												</a>
												</td>
											</tr>
											<tr height="1">
												<td></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="15"></tr>
		<tr valign="bottom" height="25">

			<td align="right"><font color="#FF0000"> * &nbsp; </font> 4 )</td>
			<td><font color="#FF0000"> Verify </font> Value Domain Long Name
				(* ISO Preferred Name)</td>

		</tr>
		<tr>
			<td>&nbsp;</td>
			<td height="24" valign="top"><input name="txtLongName"
				type="text" size="100" maxlength=255
				value="Anatomic Site Location Text Name" onKeyUp="changeCountLN();"
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtLongName',helpUrl); return false">
				&nbsp;&nbsp; <input name="txtLongNameCount" type="text" value="32"
				size="1" readonly
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtLongName',helpUrl); return false">

				<font color="#000000"> Character Count &nbsp;&nbsp;(Database
					Max = 255) </font>
			</td>
		</tr>
		<tr valign="bottom" height="25">

			<td align=right><font color="#FF0000"> * &nbsp; </font> 5 )</td>
			<td><font color="#FF0000"> Update </font> <font color="#000000">
					Value Domain Short Name </font>
			</td>

		</tr>

		<tr>
			<td>&nbsp;</td>
			<td height="24" valign="bottom">Select Short Name Naming
				Standard</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td height="24" valign="top"><input name="rNameConv"
				type="radio" value="SYS"
				onclick="javascript:SubmitValidate('changeNameType');">
				System Generated &nbsp;&nbsp;&nbsp; <input name="rNameConv"
				type="radio" value="ABBR"
				onclick="javascript:SubmitValidate('changeNameType');">
				Abbreviated &nbsp;&nbsp;&nbsp; <input name="rNameConv" type="radio"
				value="USER" onclick="javascript:SubmitValidate('changeNameType');">
				Existing Name (Editable) <!--Existing Name (Editable)  User Maintained-->
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td height="24" valign="top"><input name="txtPreferredName"
				type="text" size="100" maxlength=30 value="ANAT_SITE_LCTN_NM"
				onKeyUp="changeCountPN();" readonly
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtPreferredName',helpUrl); return false">
				&nbsp;&nbsp; <input name="txtPrefNameCount" type="text" value="17"
				size="1" readonly
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtPreferredName',helpUrl); return false">

				<font color="#000000"> Character Count &nbsp;&nbsp;(Database
					Max = 30) </font>
			</td>
		</tr>

		<tr height="25" valign="bottom">

			<td align=right><font color="#FF0000"> *&nbsp;&nbsp; </font> 6 )</td>
			<td>Public ID</td>

		</tr>
		<tr>
			<td align=right>&nbsp;</td>
			<td><font color="#C0C0C0"> <input type="text"
					name="CDE_IDTxt" value="2188327" size="20" readonly
					onHelp="showHelp('html/Help_CreateVD.html#createVDForm_CDE_IDTxt',helpUrl); return false">
			</font>
			</td>
		</tr>
		<tr>
			<td height="8" valign="top">
		</tr>
		<tr height="25" valign="top">

			<td align=right><font color="#FF0000"> * &nbsp; </font> 7 )</td>
			<td><font color="#FF0000"> Create/Edit </font> Definition</td>

		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" align="left"><textarea name="CreateDefinition"
					style="width:80%" rows=6
					onHelp="showHelp('html/Help_CreateVD.html#createVDForm_CreateDefinition',helpUrl); return false">Name of an anatomic body site.</textarea>

			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right><font color="#FF0000">
					*&nbsp;&nbsp;&nbsp; </font> 8 )</td>
			<td><font color="#FF0000"> Select <font color="#000000">

						Conceptual Domain </font> </font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><select name="selConceptualDomain" size="1"
				style="width:430" multiple
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selConceptualDomain',helpUrl); return false">
					<option value="B1ED0F8B-4D91-332D-E034-0003BA12F5E7">
						Anatomic Sites - CTEP</option>
			</select> &nbsp;&nbsp; <font color="#FF0000"> <a
					href="javascript:SearchCDValue()"> Search </a> </font>
			</td>
		</tr>

		<tr height="25" valign="bottom">
			<td align=right><font color="#FF0000"> *&nbsp; </font> 9 )</td>
			<td><font color="#FF0000"> Select <font color="#000000">

						Workflow Status 
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><select name="selStatus" size="1"
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selStatus',helpUrl); return false">
					<option value="" selected="selected"></option>

					<option value="APPRVD FOR TRIAL USE">APPRVD FOR TRIAL USE</option>

					<option value="CMTE APPROVED">CMTE APPROVED</option>

					<option value="CMTE SUBMTD">CMTE SUBMTD</option>

					<option value="CMTE SUBMTD USED">CMTE SUBMTD USED</option>

					<option value="DRAFT MOD">DRAFT MOD</option>

					<option value="DRAFT NEW">DRAFT NEW</option>

					<option value="RELEASED" selected>RELEASED</option>

					<option value="RELEASED-NON-CMPLNT">RELEASED-NON-CMPLNT</option>

					<option value="RETIRED ARCHIVED">RETIRED ARCHIVED</option>

					<option value="RETIRED DELETED">RETIRED DELETED</option>

					<option value="RETIRED PHASED OUT">RETIRED PHASED OUT</option>

					<option value="RETIRED WITHDRAWN">RETIRED WITHDRAWN</option>

			</select>
			</td>
		</tr>
		<tr height="25" valign="bottom">

			<td align=right>10 )</td>
			<td>Version</td>

		</tr>
		<tr>
			<td>&nbsp;</td>

			<td valign="top"><input type="text" name="Version" value="1.0"
				size=5 readonly
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_Version',helpUrl); return false">
				&nbsp;&nbsp;&nbsp; <a href="https://wiki.nci.nih.gov/x/TgRy"
				target="_blank"> Business Rules </a>
			</td>

		</tr>
		<tr height="25" valign="bottom">
			<td align=right><font color="#FF0000"> *&nbsp; </font> 11 )</td>
			<td><font color="#FF0000"> Select </font> Data Type</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<table width="90%" border="1">
					<col width="20%">
					<col width="20%">
					<col width="20%">
					<col width="20%">
					<col width="20%">
					<tr>
						<td valign="top"><select name="selDataType" size="1"
							onChange="javascript:changeDataType();" style="width:90%"
							onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selDataType',helpUrl); return false">

								<option value=""></option>

								<option value="Alpha DVG">Alpha DVG</option>

								<option value="ALPHANUMERIC">ALPHANUMERIC</option>

								<option value="anyClass">anyClass</option>

								<option value="binary">binary</option>

								<option value="BINARY OBJECT">BINARY OBJECT</option>

								<option value="BOOLEAN">BOOLEAN</option>

								<option value="BRIDG_SET_v2.1">BRIDG_SET_v2.1</option>

								<option value="CHARACTER" selected>CHARACTER</option>

								<option value="DATE">DATE</option>

								<option value="Date Alpha DVG">Date Alpha DVG</option>

								<option value="DATE/TIME">DATE/TIME</option>

								<option value="DATETIME">DATETIME</option>

								<option value="Derived">Derived</option>

								<option value="evs.domain.Property">
									evs.domain.Property</option>

								<option value="evs.domain.Role">evs.domain.Role</option>

								<option value="evs.domain.Source">evs.domain.Source</option>

								<option value="evs.domain.TreeNode">
									evs.domain.TreeNode</option>

								<option value="HL7PPDv3.0">HL7PPDv3.0</option>

								<option value="ISO21090ADPartv1.0">ISO21090ADPartv1.0</option>

								<option value="ISO21090ADv1.0">ISO21090ADv1.0</option>

								<option value="ISO21090ADXPADLv1.0">
									ISO21090ADXPADLv1.0</option>

								<option value="ISO21090ADXPALv1.0">ISO21090ADXPALv1.0</option>

								<option value="ISO21090ADXPBNNv1.0">
									ISO21090ADXPBNNv1.0</option>

								<option value="ISO21090ADXPBNRv1.0">
									ISO21090ADXPBNRv1.0</option>

								<option value="ISO21090ADXPBNSv1.0">
									ISO21090ADXPBNSv1.0</option>

								<option value="ISO21090ADXPBRv1.0">ISO21090ADXPBRv1.0</option>

								<option value="ISO21090ADXPCARv1.0">
									ISO21090ADXPCARv1.0</option>

								<option value="ISO21090ADXPCENv1.0">
									ISO21090ADXPCENv1.0</option>

								<option value="ISO21090ADXPCNTv1.0">
									ISO21090ADXPCNTv1.0</option>

								<option value="ISO21090ADXPCPAv1.0">
									ISO21090ADXPCPAv1.0</option>

								<option value="ISO21090ADXPCTYv1.0">
									ISO21090ADXPCTYv1.0</option>

								<option value="ISO21090ADXPDALv1.0">
									ISO21090ADXPDALv1.0</option>

								<option value="ISO21090ADXPDIAAv1.0">
									ISO21090ADXPDIAAv1.0</option>

								<option value="ISO21090ADXPDIQv1.0">
									ISO21090ADXPDIQv1.0</option>

								<option value="ISO21090ADXPDIRv1.0">
									ISO21090ADXPDIRv1.0</option>

								<option value="ISO21090ADXPDISTv1.0">
									ISO21090ADXPDISTv1.0</option>

								<option value="ISO21090ADXPDMDv1.0">
									ISO21090ADXPDMDv1.0</option>

								<option value="ISO21090ADXPDMIDv1.0">
									ISO21090ADXPDMIDv1.0</option>

								<option value="ISO21090ADXPINTv1.0">
									ISO21090ADXPINTv1.0</option>

								<option value="ISO21090ADXPPOBv1.0">
									ISO21090ADXPPOBv1.0</option>

								<option value="ISO21090ADXPPREv1.0">
									ISO21090ADXPPREv1.0</option>

								<option value="ISO21090ADXPSALv1.0">
									ISO21090ADXPSALv1.0</option>

								<option value="ISO21090ADXPSTAv1.0">
									ISO21090ADXPSTAv1.0</option>

								<option value="ISO21090ADXPSTBv1.0">
									ISO21090ADXPSTBv1.0</option>

								<option value="ISO21090ADXPSTRv1.0">
									ISO21090ADXPSTRv1.0</option>

								<option value="ISO21090ADXPSTTPv1.0">
									ISO21090ADXPSTTPv1.0</option>

								<option value="ISO21090ADXPUNIDv1.0">
									ISO21090ADXPUNIDv1.0</option>

								<option value="ISO21090ADXPUNTv1.0">
									ISO21090ADXPUNTv1.0</option>

								<option value="ISO21090ADXPv1.0">ISO21090ADXPv1.0</option>

								<option value="ISO21090ADXPZIPv1.0">
									ISO21090ADXPZIPv1.0</option>

								<option value="ISO21090ANYv1.0">ISO21090ANYv1.0</option>

								<option value="ISO21090BAGv1.0">ISO21090BAGv1.0</option>

								<option value="ISO21090BLNTNULv1.0">
									ISO21090BLNTNULv1.0</option>

								<option value="ISO21090BLv1.0">ISO21090BLv1.0</option>

								<option value="ISO21090CDBasev1.0">ISO21090CDBasev1.0</option>

								<option value="ISO21090CDCVv1.0">ISO21090CDCVv1.0</option>

								<option value="ISO21090CDv1.0">ISO21090CDv1.0</option>

								<option value="ISO21090COLLv1.0">ISO21090COLLv1.0</option>

								<option value="ISO21090COv1.0">ISO21090COv1.0</option>

								<option value="ISO21090CSv1.0">ISO21090CSv1.0</option>

								<option value="ISO21090DSETv1.0">ISO21090DSETv1.0</option>

								<option value="ISO21090EDDCINLINv1.">
									ISO21090EDDCINLINv1.</option>

								<option value="ISO21090EDDCREFv1.0">
									ISO21090EDDCREFv1.0</option>

								<option value="ISO21090EDIMAGEv1.0">
									ISO21090EDIMAGEv1.0</option>

								<option value="ISO21090EDSIGNAT1.0">
									ISO21090EDSIGNAT1.0</option>

								<option value="ISO21090EDSTRTITv1.0">
									ISO21090EDSTRTITv1.0</option>

								<option value="ISO21090EDSTRTXv1.0">
									ISO21090EDSTRTXv1.0</option>

								<option value="ISO21090EDTEXTv1.0">ISO21090EDTEXTv1.0</option>

								<option value="ISO21090EDv1.0">ISO21090EDv1.0</option>

								<option value="ISO21090EIVLv1.0">ISO21090EIVLv1.0</option>

								<option value="ISO21090ENONv1.0">ISO21090ENONv1.0</option>

								<option value="ISO21090ENPNv1.0">ISO21090ENPNv1.0</option>

								<option value="ISO21090ENTNv1.0">ISO21090ENTNv1.0</option>

								<option value="ISO21090ENV1.0">ISO21090ENV1.0</option>

								<option value="ISO21090ENXPv1.0">ISO21090ENXPv1.0</option>

								<option value="ISO21090GLISTv1.0">ISO21090GLISTv1.0</option>

								<option value="ISO21090GTSBPIVLv1.0">
									ISO21090GTSBPIVLv1.0</option>

								<option value="ISO21090HISTv1.0">ISO21090HISTv1.0</option>

								<option value="ISO21090HXITv1.0">ISO21090HXITv1.0</option>

								<option value="ISO21090IIv1.0">ISO21090IIv1.0</option>

								<option value="ISO21090INTNTNEGv1.0">
									ISO21090INTNTNEGv1.0</option>

								<option value="ISO21090INTPOSv1.0">ISO21090INTPOSv1.0</option>

								<option value="ISO21090INTv1.0">ISO21090INTv1.0</option>

								<option value="ISO21090IVLHIGHv1.0">
									ISO21090IVLHIGHv1.0</option>

								<option value="ISO21090IVLLOWv1.0">ISO21090IVLLOWv1.0</option>

								<option value="ISO21090IVLv1.0">ISO21090IVLv1.0</option>

								<option value="ISO21090IVLWIDv1.0">ISO21090IVLWIDv1.0</option>

								<option value="ISO21090LISTv1.0">ISO21090LISTv1.0</option>

								<option value="ISO21090MOv1.0">ISO21090MOv1.0</option>

								<option value="ISO21090NPPDv1.0">ISO21090NPPDv1.0</option>

								<option value="ISO21090PIVLv1.0">ISO21090PIVLv1.0</option>

								<option value="ISO21090PQRv1.0">ISO21090PQRv1.0</option>

								<option value="ISO21090PQTIMEv1.0">ISO21090PQTIMEv1.0</option>

								<option value="ISO21090PQv1.0">ISO21090PQv1.0</option>

								<option value="ISO21090PQVv1.0">ISO21090PQVv1.0</option>

								<option value="ISO21090QSCv1.0">ISO21090QSCv1.0</option>

								<option value="ISO21090QSDv1.0">ISO21090QSDv1.0</option>

								<option value="ISO21090QSETv1.0">ISO21090QSETv1.0</option>

								<option value="ISO21090QSIv1.0">ISO21090QSIv1.0</option>

								<option value="ISO21090QSPv1.0">ISO21090QSPv1.0</option>

								<option value="ISO21090QSSv1.0">ISO21090QSSv1.0</option>

								<option value="ISO21090QSUv1.0">ISO21090QSUv1.0</option>

								<option value="ISO21090QTYv1.0">ISO21090QTYv1.0</option>

								<option value="ISO21090REALv1.0">ISO21090REALv1.0</option>

								<option value="ISO21090RTOv1.0">ISO21090RTOv1.0</option>

								<option value="ISO21090SCNTv1.0">ISO21090SCNTv1.0</option>

								<option value="ISO21090SCv1.0">ISO21090SCv1.0</option>

								<option value="ISO21090SLISTv1.0">ISO21090SLISTv1.0</option>

								<option value="ISO21090STNTv1.0">ISO21090STNTv1.0</option>

								<option value="ISO21090StrDCapedv1.">
									ISO21090StrDCapedv1.</option>

								<option value="ISO21090StrDcClGpv1.">
									ISO21090StrDcClGpv1.</option>

								<option value="ISO21090StrDcCMCtv1.">
									ISO21090StrDcCMCtv1.</option>

								<option value="ISO21090StrDcCMFtntv">
									ISO21090StrDcCMFtntv</option>

								<option value="ISO21090StrDcCMGv1.0">
									ISO21090StrDcCMGv1.0</option>

								<option value="ISO21090StrDcCMInlv1">
									ISO21090StrDcCMInlv1</option>

								<option value="ISO21090StrDcCMTitv1">
									ISO21090StrDcCMTitv1</option>

								<option value="ISO21090StrDcContv1.">
									ISO21090StrDcContv1.</option>

								<option value="ISO21090StrDcFtnRfv1">
									ISO21090StrDcFtnRfv1</option>

								<option value="ISO21090StrDcFtnv1.0">
									ISO21090StrDcFtnv1.0</option>

								<option value="ISO21090StrDcItemv1.">
									ISO21090StrDcItemv1.</option>

								<option value="ISO21090StrDcLenv1.0">
									ISO21090StrDcLenv1.0</option>

								<option value="ISO21090StrDcLHtmlv1">
									ISO21090StrDcLHtmlv1</option>

								<option value="ISO21090StrDcListv1.">
									ISO21090StrDcListv1.</option>

								<option value="ISO21090StrDcPargv1.">
									ISO21090StrDcPargv1.</option>

								<option value="ISO21090StrDcRdMMv1.">
									ISO21090StrDcRdMMv1.</option>

								<option value="ISO21090StrDcSubv1.0">
									ISO21090StrDcSubv1.0</option>

								<option value="ISO21090StrDcTbleIt1">
									ISO21090StrDcTbleIt1</option>

								<option value="ISO21090StrDcTblev1.">
									ISO21090StrDcTblev1.</option>

								<option value="ISO21090StrDcTcellv1">
									ISO21090StrDcTcellv1</option>

								<option value="ISO21090StrDcTCelv1.">
									ISO21090StrDcTCelv1.</option>

								<option value="ISO21090StrDcTitFtv1">
									ISO21090StrDcTitFtv1</option>

								<option value="ISO21090StrDcTRGrpv1">
									ISO21090StrDcTRGrpv1</option>

								<option value="ISO21090StrDcTRPtv1.">
									ISO21090StrDcTRPtv1.</option>

								<option value="ISO21090StrDcTRv1.0">
									ISO21090StrDcTRv1.0</option>

								<option value="ISO21090StrDocBav1.0">
									ISO21090StrDocBav1.0</option>

								<option value="ISO21090StrDocBrv1.0">
									ISO21090StrDocBrv1.0</option>

								<option value="ISO21090StrDocCapv1.">
									ISO21090StrDocCapv1.</option>

								<option value="ISO21090StrDocClItv1">
									ISO21090StrDocClItv1</option>

								<option value="ISO21090StrDocColv1.">
									ISO21090StrDocColv1.</option>

								<option value="ISO21090StrDocSupv1.">
									ISO21090StrDocSupv1.</option>

								<option value="ISO21090StrDocTextv1">
									ISO21090StrDocTextv1</option>

								<option value="ISO21090StrDocTitv1.">
									ISO21090StrDocTitv1.</option>

								<option value="ISO21090STSIMv1.0">ISO21090STSIMv1.0</option>

								<option value="ISO21090STv1.0">ISO21090STv1.0</option>

								<option value="ISO21090TELEMAILv1.0">
									ISO21090TELEMAILv1.0</option>

								<option value="ISO21090TELPERSv1.0">
									ISO21090TELPERSv1.0</option>

								<option value="ISO21090TELPHONv1.0">
									ISO21090TELPHONv1.0</option>

								<option value="ISO21090TELURLv1.0">ISO21090TELURLv1.0</option>

								<option value="ISO21090TELv1.0">ISO21090TELv1.0</option>

								<option value="ISO21090TSBIRTHv1.0">
									ISO21090TSBIRTHv1.0</option>

								<option value="ISO21090TSDATEv1.0">ISO21090TSDATEv1.0</option>

								<option value="ISO21090TSDATFLv1.0">
									ISO21090TSDATFLv1.0</option>

								<option value="ISO21090TSDTTIFLv1.0">
									ISO21090TSDTTIFLv1.0</option>

								<option value="ISO21090TSDTTIv1.0">ISO21090TSDTTIv1.0</option>

								<option value="ISO21090TSv1.0">ISO21090TSv1.0</option>

								<option value="ISO21090Tv1.0">ISO21090Tv1.0</option>

								<option value="ISO21090URGHIGHv1.0">
									ISO21090URGHIGHv1.0</option>

								<option value="ISO21090URGLOWv1.0">ISO21090URGLOWv1.0</option>

								<option value="ISO21090URGv1.0">ISO21090URGv1.0</option>

								<option value="ISO21090UVPv1.0">ISO21090UVPv1.0</option>

								<option value="java.lang.Boolean">java.lang.Boolean</option>

								<option value="java.lang.Byte">java.lang.Byte</option>

								<option value="java.lang.Character">
									java.lang.Character</option>

								<option value="java.lang.Double">java.lang.Double</option>

								<option value="java.lang.Float">java.lang.Float</option>

								<option value="java.lang.Integer">java.lang.Integer</option>

								<option value="java.lang.Integer[]">
									java.lang.Integer[]</option>

								<option value="java.lang.Long">java.lang.Long</option>

								<option value="java.lang.Object">java.lang.Object</option>

								<option value="java.lang.Short">java.lang.Short</option>

								<option value="java.lang.String">java.lang.String</option>

								<option value="java.lang.String[]">java.lang.String[]</option>

								<option value="java.lang.String[][]">
									java.lang.String[][]</option>

								<option value="java.lang.Void">java.lang.Void</option>

								<option value="java.math.BigDecimal">
									java.math.BigDecimal</option>

								<option value="java.sql.Blob">java.sql.Blob</option>

								<option value="java.sql.Clob">java.sql.Clob</option>

								<option value="java.sql.Timestamp">java.sql.Timestamp</option>

								<option value="java.util.ArrayList">
									java.util.ArrayList</option>

								<option value="java.util.Collection">
									java.util.Collection</option>

								<option value="java.util.Date">java.util.Date</option>

								<option value="java.util.HashSet">java.util.HashSet</option>

								<option value="java.util.Hashtable">
									java.util.Hashtable</option>

								<option value="java.util.Map">java.util.Map</option>

								<option value="java.util.Set">java.util.Set</option>

								<option value="java.util.Vector">java.util.Vector</option>

								<option value="MutableTreeNote">MutableTreeNote</option>

								<option value="NUMBER">NUMBER</option>

								<option value="Numeric Alpha DVG">Numeric Alpha DVG</option>

								<option value="OBJECT">OBJECT</option>

								<option value="String Array">String Array</option>

								<option value="SVG">SVG</option>

								<option value="TABLE">TABLE</option>

								<option value="TIME">TIME</option>

								<option value="UMLBinaryv1.0">UMLBinaryv1.0</option>

								<option value="UMLBooleanv1.0">UMLBooleanv1.0</option>

								<option value="UMLCodev1.0">UMLCodev1.0</option>

								<option value="UMLOctetv1.0">UMLOctetv1.0</option>

								<option value="UMLUidv1.0">UMLUidv1.0</option>

								<option value="UMLUriv1.0">UMLUriv1.0</option>

								<option value="UMLXMLv1.0">UMLXMLv1.0</option>

								<option value="xsd:anyURI">xsd:anyURI</option>

								<option value="xsd:base64Binary">xsd:base64Binary</option>

								<option value="xsd:boolean">xsd:boolean</option>

								<option value="xsd:byte">xsd:byte</option>

								<option value="xsd:date">xsd:date</option>

								<option value="xsd:dateTime">xsd:dateTime</option>

								<option value="xsd:decimal">xsd:decimal</option>

								<option value="xsd:double">xsd:double</option>

								<option value="xsd:float">xsd:float</option>

								<option value="xsd:ID">xsd:ID</option>

								<option value="xsd:IDREF">xsd:IDREF</option>

								<option value="xsd:int">xsd:int</option>

								<option value="xsd:integer">xsd:integer</option>

								<option value="xsd:long">xsd:long</option>

								<option value="xsd:short">xsd:short</option>

								<option value="xsd:string">xsd:string</option>

								<option value="xsd:time">xsd:time</option>

						</select>
						</td>

						<td valign="top" height="25"><b> Description: </b> <br>
							<label id="lblDTDesc" for="selDataType" style="width:95%"
							title="">A character string of letters, symbols, and/or
								numbers</label>
						</td>
						<td valign="top" height="25"><b> Comment: </b> <br> <label
							id="lblDTComment" for="selDataType" style="width:95%" title=""></label>
						</td>
						<td valign="top" height="25"><b> Scheme-Reference: </b> <br>
							<label id="lblDTSRef" for="selDataType" style="width:95%"
							title="">Not Specified</label>
						</td>
						<td valign="top" height="25"><b> Annotation: </b> <br> <label
							id="lblDTAnnotation" for="selDataType" style="width:95%" title=""></label>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr height="10">
			<td></td>
		</tr>
		<tr valign="top">
			<td align=right><font color="#FF0000"> * </font> 12 )</td>
			<td><font color="#FF0000"> Maintain </font> Permissible Value <br>
				To view or maintain Permissible Values, <a
				href="javascript:SubmitValidate('vdpvstab');"> [click here] </a>
				&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>

		<tr height="15">
			<td></td>
		</tr>
		<tr height="25" valign=bottom>
			<td align=right>13 )</td>
			<td><font color="#FF0000"> Enter/Select </font> Effective Begin
				Date</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="top"><input type="text" name="BeginDate"
				value="09/10/2004" size="12" maxlength=10
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BeginDate',helpUrl); return false">

				<img src="../../cdecurate/images/calendarbutton.gif"
				onclick="calendar('BeginDate', event);">

				&nbsp;&nbsp;MM/DD/YYYY</td>
		</tr>

		<tr height="25" valign="bottom">
			<td align=right>14 )</td>
			<td><font color="#FF0000"> Enter/Select </font> Effective End
				Date</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="EndDate" value="" size="12"
				maxlength=10
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_EndDate',helpUrl); return false">

				<img src="../../cdecurate/images/calendarbutton.gif"
				onclick="calendar('EndDate', event);"> &nbsp;&nbsp;MM/DD/YYYY
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>15 )</td>
			<td><font color="#FF0000"> Select </font> Unit of Measure (UOM)
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><select name="selUOM" size="1"
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selUOM',helpUrl); return false">
					<option value="" selected></option>

					<option value="%">%</option>

					<option value="1000/mm3">1000/mm3</option>

					<option value="1000/uL">1000/uL</option>

					<option value="10E7 cells/Kg">10E7 cells/Kg</option>

					<option value="10E9/L">10E9/L</option>

					<option value="bpm">bpm</option>

					<option value="cc/min">cc/min</option>

					<option value="cells/L">cells/L</option>

					<option value="cells/mL">cells/mL</option>

					<option value="cells/uL">cells/uL</option>

					<option value="cGy">cGy</option>

					<option value="Ci/mmol">Ci/mmol</option>

					<option value="cm">cm</option>

					<option value="cm H2O">cm H2O</option>

					<option value="counts/cm2">counts/cm2</option>

					<option value="day">day</option>

					<option value="EU/Kg ">EU/Kg</option>

					<option value="g/24 hours">g/24 hours</option>

					<option value="g/dL">g/dL</option>

					<option value="g/L">g/L</option>

					<option value="gm">gm</option>

					<option value="Gray">Gray</option>

					<option value="in">in</option>

					<option value="iU/L">iU/L</option>

					<option value="IU/mL">IU/mL</option>

					<option value="Kg">Kg</option>

					<option value="kg/m2">kg/m2</option>

					<option value="kPa">kPa</option>

					<option value="kV">kV</option>

					<option value="l">l</option>

					<option value="L/min">L/min</option>

					<option value="lb">lb</option>

					<option value="M">M</option>

					<option value="m2">m2</option>

					<option value="mcg/l">mcg/l</option>

					<option value="mCi">mCi</option>

					<option value="mEq/L">mEq/L</option>

					<option value="mg">mg</option>

					<option value="mg/24 hours">mg/24 hours</option>

					<option value="mg/dL">mg/dL</option>

					<option value="mg/L">mg/L</option>

					<option value="mGy">mGy</option>

					<option value="mGy-cm">mGy-cm</option>

					<option value="MHz">MHz</option>

					<option value="min">min</option>

					<option value="min(-1)">min(-1)</option>

					<option value="Mitosis/10 HPF">Mitosis/10 HPF</option>

					<option value="mIU/mL">mIU/mL</option>

					<option value="ml">ml</option>

					<option value="ml/hr">ml/hr</option>

					<option value="ml/min">ml/min</option>

					<option value="mL/Min/1.73m2">mL/Min/1.73m2</option>

					<option value="mL/min/g ">mL/min/g</option>

					<option value="mm">mm</option>

					<option value="mm/hour">mm/hour</option>

					<option value="mm/sec">mm/sec</option>

					<option value="mm3">mm3</option>

					<option value="mmHg">mmHg</option>

					<option value="mmol/L">mmol/L</option>

					<option value="months">months</option>

					<option value="ms">ms</option>

					<option value="mU/L">mU/L</option>

					<option value="N/A">N/A</option>

					<option value="ng/dl">ng/dl</option>

					<option value="ng/ml">ng/ml</option>

					<option value="number">number</option>

					<option value="pg/mL">pg/mL</option>

					<option value="seconds">seconds</option>

					<option value="U/L">U/L</option>

					<option value="ug">ug</option>

					<option value="ug/l">ug/l</option>

					<option value="ug/mg Creatinine">ug/mg Creatinine</option>

					<option value="ug/mL">ug/mL</option>

					<option value="ug/ul">ug/ul</option>

					<option value="ul">ul</option>

					<option value="um">um</option>

					<option value="uM x min">uM x min</option>

					<option value="umol ">umol</option>

					<option value="umol/L">umol/L</option>

					<option value="units/mL">units/mL</option>

					<option value="Vol Frac">Vol Frac</option>

					<option value="x1000">x1000</option>

					<option value="year">year</option>

					<option value="°C">°C</option>

			</select>
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>16 )</td>
			<td><font color="#FF0000"> Select </font> Display Format</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><select name="selUOMFormat" size="1"
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selUOMFormat',helpUrl); return false">
					<option value="" selected></option>

					<option value="%">%</option>

					<option value="10,3">10,3</option>

					<option value="9.999 ">9.999</option>

					<option value="99.9">99.9</option>

					<option value="99.99">99.99</option>

					<option value="999-99-9999">999-99-9999</option>

					<option value="999.9">999.9</option>

					<option value="999.99">999.99</option>

					<option value="999.9999">999.9999</option>

					<option value="9999.9">9999.9</option>

					<option value="9999.99">9999.99</option>

					<option value="9999.999">9999.999</option>

					<option value="99999.99">99999.99</option>

					<option value="999999.9">999999.9</option>

					<option value="9999999">9999999</option>

					<option value="DATE">DATE</option>

					<option value="DD/MON/YYYY">DD/MON/YYYY</option>

					<option value="DY/MTH/YR">DY/MTH/YR</option>

					<option value="hh">hh</option>

					<option value="hh:mm">hh:mm</option>

					<option value="hh:mm:ss">hh:mm:ss</option>

					<option value="hh:mm:ss:rr">hh:mm:ss:rr</option>

					<option value="hhmm">hhmm</option>

					<option value="hhmmss">hhmmss</option>

					<option value="mm/dd/yy">mm/dd/yy</option>

					<option value="MM/DD/YYYY">MM/DD/YYYY</option>

					<option value="mm/dd/yyyy">mm/dd/yyyy</option>

					<option value="MMDDYYYY">MMDDYYYY</option>

					<option value="MMYYYY">MMYYYY</option>

					<option value="MON/DD/YYYY">MON/DD/YYYY</option>

					<option value="N/A">N/A</option>

					<option value="TIME (HR(24):MN)">TIME (HR(24):MN)</option>

					<option value="TIME_HH:MM">TIME_HH:MM</option>

					<option value="TIME_MIN">TIME_MIN</option>

					<option value="xx-xxx-xxx">xx-xxx-xxx</option>

					<option value="YYYY">YYYY</option>

					<option value="YYYY ">YYYY</option>

					<option value="YYYY-MM-DD">YYYY-MM-DD</option>

					<option value="YYYYMM">YYYYMM</option>

					<option value="YYYYMMDD">YYYYMMDD</option>

			</select>
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>17 )</td>
			<td><font color="#FF0000"> Enter </font> Minimum Length</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="tfMinLength" value="" size="20"
				maxlength=8
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfMinLength',helpUrl); return false">
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>18 )</td>
			<td><font color="#FF0000"> Enter </font> Maximum Length</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="tfMaxLength" value="30" size="20"
				maxlength=8
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfMaxLength',helpUrl); return false">
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>19 )</td>
			<td><font color="#FF0000"> Enter </font> Low Value (for number
				data type)</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="tfLowValue" value="" size="20"
				maxlength=255 disabled
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfLowValue',helpUrl); return false">
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>20 )</td>
			<td><font color="#FF0000"> Enter </font> High Value (for number
				data type)</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="tfHighValue" value="" size="20"
				maxlength=255 disabled
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfHighValue',helpUrl); return false">
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>21 )</td>
			<td><font color="#FF0000"> Enter </font> Decimal Place</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="tfDecimal" value="" size="20"
				maxlength=2
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfDecimal',helpUrl); return false">
			</td>
		</tr>
		<!-- Classification Scheme and items -->
		<tr height="25" valign="bottom">
			<td align=right>22 )</td>
			<td><font color="#FF0000"> Select </font> Classification Scheme
				and Classification Scheme Items</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>
				<table width=90% border=0>
					<col width="1%">
					<col width="38%">
					<col width="16%">
					<col width="38%">
					<col width="16%">

					<tr>
						<td colspan=3 valign=top><select name="selCS" size="1"
							style="width:97%" onChange="ChangeCS();"
							onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">

								<option value="" selected></option>

								<option value="CE7583F8-BF56-BCEB-E040-BB89AD4314C0">
									10 PROMIS Global Health Questionnaire - caBIG- 3626265 v 1.0</option>

								<option value="2C39E82F-DEC1-6BF9-E044-0003BA3F9857">
									ACRIN - caBIG- 2614823 v 1.0</option>

								<option value="B48A05B8-D5F0-3D4F-E040-BB89AD4359F5">
									Adult Brain Tumor Consortium (ABTC) - CTEP- 3335728 v 1.0</option>

								<option value="BEC052E5-F163-7484-E034-0003BA12F5E7">
									Adult Soft Tissue New - CTEP- 2008603 v 1.0</option>

								<option value="0D52AFEF-A558-4930-E044-0003BA3F9857">
									Advanced Training Examples - Training- 2451850 v 1.0</option>

								<option value="F2C441CC-5CB1-53CD-E034-0003BA3F9857">
									Adverse Events - CIP- 2201295 v 1.0</option>

								<option value="FF807FAF-3209-1228-E034-0003BA3F9857">
									Agency - Training- 2399264 v 1.0</option>

								<option value="2C39EB56-CE53-6AF0-E044-0003BA3F9857">
									AIM - caBIG- 2614824 v 1.0</option>

								<option value="8561CDCB-FA44-201E-E040-BB89AD434E66">
									AIM 1.5 - caBIG- 3079208 v 1.5</option>

								<option value="7ABCFDEF-3DC9-A801-E040-BB89AD436922">
									AIM 2.0 - caBIG- 2614824 v 2.0</option>

								<option value="8F3967CC-A544-5851-E040-BB89AD437E5D">
									AIM 3.0 - caBIG- 2614824 v 3.0</option>

								<option value="CC203453-D86E-69AA-E040-BB89AD43124D">
									AIM 4.0 - caBIG- 2614824 v 4.0</option>

								<option value="CAB61238-7D15-A72C-E040-BB89AD4325AC">
									AIM Foundation Model - caBIG- 3599505 v 4.0</option>

								<option value="9908CAE4-B4C1-B44B-E040-BB89AD434D5C">
									All Candidates - caBIG- 3180886 v 1.0</option>

								<option value="3D6661B1-1B8E-2ADE-E044-0003BA3F9857">
									Application Development - TEST- 2691542 v 1.0</option>

								<option value="41A940C4-4F40-5671-E044-0003BA3F9857">
									ASCO (American Society of Clinical Oncology) - caBIG- 2716207 v
									1.0</option>

								<option value="CE52F289-45F0-320C-E040-BB89AD430C35">
									ASC_Assessment of Survivor Concerns - caBIG- 3626149 v 1.0</option>

								<option value="9BBEC9D2-6812-64B6-E040-BB89AD431F76">
									Australian Cancer Registry - caBIG- 3190117 v 1.0</option>

								<option value="CE756ABD-FD9C-9F5A-E040-BB89AD436B22">
									BCT Outcomes_Breast Cancer Treatment Outcomes Questionnaire -
									caBIG- 3626262 v 1.0</option>

								<option value="2C3B4E34-6BE5-7445-E044-0003BA3F9857">
									BDT - caBIG- 2614832 v 1.0</option>

								<option value="4DDB7B3D-6453-5599-E044-0003BA3F9857">
									BehavioralResearchMeasures - caBIG- 2751568 v 1.0</option>

								<option value="4DDCA3F1-88E0-434B-E044-0003BA3F9857">
									Behavioral_Research_Measures - PS&CC- 2751668 v 1.0</option>

								<option value="3D6663F3-0844-2AEA-E044-0003BA3F9857">
									BIC Scientific Analysis - TEST- 2691543 v 1.0</option>

								<option value="9A9A36E8-7E43-8B01-E040-BB89AD434EBF">
									BIGHealth ePRO Data Dictionary - caBIG- 3185645 v 1.0</option>

								<option value="2F05DE51-D674-2AC1-E044-0003BA3F9857">
									Bioconductor - caBIG- 2632574 v 1.0</option>

								<option value="3D3AB327-34F1-2D63-E044-0003BA3F9857">
									Biosense - TEST- 2691326 v 1.0</option>

								<option value="38209E16-D54F-71E8-E044-0003BA3F9857">
									BiospecimenCoreResource - caBIG- 2673170 v 1.0</option>

								<option value="CE7571A1-6AD0-1CB2-E040-BB89AD4312F6">
									BIS_Body Image Scale - caBIG- 3626263 v 1.0</option>

								<option value="CA0022E4-868F-B0A2-E040-BB89AD4361FF">
									BLGSP (Burkitt Lymphoma Genome Sequencing Project) - caBIG-
									3590028 v 1.0</option>

								<option value="C02F3EC9-DCD7-36C6-E040-BB89AD432AAF">
									BOLD:Breast Oncology Local Disease - caBIG- 3461586 v 1.0</option>

								<option value="684C9ACF-9771-2D40-E040-BB89AD430A3D">
									BootCampModel - Training- 2863101 v 1.0</option>

								<option value="49BD84D0-4486-6196-E044-0003BA3F9857">
									Breast and Colon Cancer Family Registries - caBIG- 2738437 v
									1.0</option>

								<option value="C73BEFD4-A727-C23E-E040-BB89AD437D88">
									BRIDG - NHLBI- 3553940 v 1.0</option>

								<option value="41A60465-2C56-012A-E044-0003BA3F9857">
									BRIDG 1.0 - caBIG- 2714898 v 1.0</option>

								<option value="691C9630-C49E-B8BF-E040-BB89AD4352A4">
									BRIDG 2.1 - caBIG- 2714898 v 2.1</option>

								<option value="97F20A4E-A1F1-0A70-E040-BB89AD4334BC">
									BRIDG 3.0.2 - caBIG- 2714898 v 3.02</option>

								<option value="FBB45DB6-CEEA-6EA7-E034-0003BA3F9857">
									C3D Adopter CDEs for Reuse - CCR- 2857175 v 1.0</option>

								<option value="70574F11-4AE5-91F2-E040-BB89AD430787">
									C3D Connector - caBIG- 2927077 v 1.5</option>

								<option value="B93D703A-E238-5E14-E034-0003BA12F5E7">
									C3D Domain - CCR- 2008601 v 1.0</option>

								<option value="D663F68A-A13B-126C-E034-0003BA12F5E7">
									C3D Retired - CCR- 2182091 v 1.0</option>

								<option value="24086502-840B-5F93-E044-0003BA3F9857">
									C3PR - caBIG- 2551427 v 1.1</option>

								<option value="7DAE4FAF-E704-ACD8-E040-BB89AD437D45">
									C3PR - caBIG- 2551427 v 2.8</option>

								<option value="0D2C9428-A823-66F5-E044-0003BA3F9857">
									C3PR - caBIG- 2857163 v 1.0</option>

								<option value="48423D6F-AD86-60D5-E044-0003BA3F9857">
									C3PR - caBIG- 2551427 v 2.0</option>

								<option value="7E140253-E593-9CFC-E040-BB89AD437E1D">
									caAERS - caBIG- 2747429 v 2.0</option>

								<option value="4C9692A2-2A7F-410E-E044-0003BA3F9857">
									caAERS - caBIG- 2747429 v 1.0</option>

								<option value="6BD9B3A8-BF58-3B21-E040-BB89AD435DA3">
									caArray - caBIG- 2898900 v 1.0</option>

								<option value="53F4B061-3621-605F-E044-0003BA3F9857">
									caArray - caBIG- 2726654 v 2.1</option>

								<option value="456A933F-BB2B-2919-E044-0003BA3F9857">
									caArray - caBIG- 2726654 v 2.0</option>

								<option value="6BD8FC52-BA4D-0EB4-E040-BB89AD437873">
									caArray Internal - caBIG- 2898532 v 2.3</option>

								<option value="8AF4BB9C-6855-F0D2-E040-BB89AD437DDD">
									caArray Internal - caBIG- 2898532 v 2.4</option>

								<option value="75E67C21-09E6-D7DF-E040-BB89AD43617D">
									caArray Service - caBIG- 2953481 v 1.0</option>

								<option value="2134FF55-8EDB-245D-E044-0003BA3F9857">
									caArray_1.1 - caBIG- 2534950 v 1.1</option>

								<option value="7AA8D6F4-70E7-4312-E040-BB89AD436715">
									caBIG Integration Hub - caBIG- 2768653 v 2.0</option>

								<option value="7CDC3DB2-B131-1EFE-E040-BB89AD4305A3">
									caBIGGridEnabledMeasures - caBIG- 2983652 v 1.0</option>

								<option value="418E966B-BE2D-1611-E044-0003BA3F9857">
									caBIO 4.0 - caBIG- 2714661 v 4.0</option>

								<option value="4ED641EC-EEC3-6F93-E044-0003BA3F9857">
									caBIO 4.1 - caBIG- 2714661 v 4.1</option>

								<option value="67237A8D-61A7-764F-E040-BB89AD434DDA">
									caBIO 4.2 - caBIG- 2714661 v 4.2</option>

								<option value="73280E93-DA32-9619-E040-BB89AD43148C">
									caBIO 4.3 - caBIG- 2939183 v 4.3</option>

								<option value="F621108B-4019-4D19-E034-0003BA3F9857">
									caCORE 3.0 - caCORE- 2857173 v 3.0</option>

								<option value="20303F9E-7450-07AB-E044-0003BA3F9857">
									caCORE 3.1 - caCORE- 2528431 v 3.1</option>

								<option value="35F79F32-3D0B-6F92-E044-0003BA3F9857">
									caCORE 3.2 - caCORE- 2528431 v 3.2</option>

								<option value="246E0563-EBB6-5E10-E044-0003BA3F9857">
									caCORE Reload caDSR 3.1 - caCORE- 2552422 v 3.1</option>

								<option value="61FA900C-88F1-B7D4-E040-BB89AD436FEA">
									caCORRECT - caBIG- 2831137 v 1.0</option>

								<option value="2C3B50CF-667E-701F-E044-0003BA3F9857">
									CAD Markup - caBIG- 2614833 v 1.0</option>

								<option value="2C3B4E34-6BF8-7445-E044-0003BA3F9857">
									CAD Order - caBIG- 2614834 v 1.0</option>

								<option value="7AB38415-EF55-E453-E040-BB89AD431E44">
									caDSR 4.0 - caBIG- 2967376 v 4.0</option>

								<option value="DA3C1331-1940-68F5-E034-0003BA12F5E7">
									caDSRTraining - caCORE- 2183712 v 1.0</option>

								<option value="61A11AA0-0A6D-9145-E040-BB89AD43013D">
									caElmir - caBIG- 2619399 v 2.0</option>

								<option value="2CBEBB83-C4B6-4BF3-E044-0003BA3F9857">
									caElmir - caBIG- 2619399 v 1.0</option>

								<option value="344B3BED-DAEC-6F5F-E044-0003BA3F9857">
									caFE Server - caBIG- 2661628 v 2.0</option>

								<option value="24FB8B34-0391-45C9-E044-0003BA3F9857">
									caFE Server - caBIG- 2557869 v 1.2</option>

								<option value="062BF8AF-3F9B-6B12-E044-0003BA3F9857">
									caFE Server 1.0 - caBIG- 2857188 v 1.0</option>

								<option value="1B8C6AEB-FEAE-6F49-E044-0003BA3F9857">
									caFE Server 1.1 - caBIG- 2514015 v 1.1</option>

								<option value="70594EE1-21DD-3DBE-E040-BB89AD4323B2">
									caGrid - caBIG- 2927833 v 1.0</option>

								<option value="7058FCBA-3EEF-3D77-E040-BB89AD43616E">
									caGrid_Metadata_Models - caBIG- 2927589 v 1.0</option>

								<option value="20412C2B-A84B-5AC6-E044-0003BA3F9857">
									caIntegrator - caBIG- 2528519 v 2.0</option>

								<option value="40A18532-9DE4-358D-E044-0003BA3F9857">
									caIntegrator 2.1 - caBIG- 2707890 v 2.1</option>

								<option value="27A7783F-6F5F-15E8-E044-0003BA3F9857">
									Caisis - caBIG- 2589983 v 3.5</option>

								<option value="876EB6B9-2BE1-C4A9-E040-BB89AD430A5D">
									caLIMS2 - caBIG- 2772168 v 1.1</option>

								<option value="54473CF7-96EB-297A-E044-0003BA3F9857">
									caLIMS2 - caBIG- 2772168 v 1.0</option>

								<option value="4FF648EC-6DC4-1716-E044-0003BA3F9857">
									caMatch - caBIG- 2760132 v 1.0</option>

								<option value="212235F0-A404-3791-E044-0003BA3F9857">
									caMOD - caBIG- 2534690 v 2.1</option>

								<option value="5571F1C3-B334-1C71-E044-0003BA3F9857">
									caMOD_2.5 - caBIG- 2534690 v 2.5</option>

								<option value="4569C98A-2758-12B6-E044-0003BA3F9857">
									caNano - caBIG- 2726207 v 1.0</option>

								<option value="6E33024F-A160-6560-E040-BB89AD4316A9">
									caNanoLab - caBIG- 2915522 v 1.5</option>

								<option value="4DE86566-9EC2-6BAE-E044-0003BA3F9857">
									caNanoLab - caBIG- 2612100 v 1.4</option>

								<option value="2BA65C6C-B62F-5779-E044-0003BA3F9857">
									caNanoLab - caBIG- 2612100 v 1.0</option>

								<option value="07F99A17-CC32-58B8-E044-0003BA3F9857">
									Cancer Models Database 2.0 - caBIG- 2857162 v 1.0</option>

								<option value="0D681351-93BB-1A16-E044-0003BA3F9857">
									Cancer Molecular Pages - caBIG- 2857164 v 1.0</option>

								<option value="8C748BD2-FA2D-BA96-E040-BB89AD430A22">
									cancer Ontology Based Resources - caBIG- 3124706 v 1.0</option>

								<option value="A4491DBE-1959-969B-E040-BB89AD4378DA">
									Cancer Registries Project - caBIG- 3241357 v 1.0</option>

								<option value="2998CD52-3F56-4631-E044-0003BA3F9857">
									Cancer(NCDE) - caBIG- 2597547 v 1.0</option>

								<option value="05DCD308-FCC6-2AF6-E044-0003BA3F9857">
									CAP Cancer Checklists - caBIG- 2857187 v 1.0</option>

								<option value="5C775919-89B7-0123-E044-0003BA3F9857">
									Cardiovascular Model - caBIG- 2804809 v 1.0</option>

								<option value="26CFF465-C6D4-1626-E044-0003BA3F9857">
									Cardiovascular Project - TEST- 2586708 v 1.0</option>

								<option value="81C800FA-3EB4-9924-E040-BB89AD431B80">
									Caris Life Sciences - caBIG- 3021954 v 1.0</option>

								<option value="FF02039F-0F27-7197-E034-0003BA3F9857">
									CARRIAGE RETURN TEST CS - TEST- 2391015 v 1.0</option>

								<option value="67858A35-7496-CFD4-E040-BB89AD4365FF">
									caSEER - PS&CC- 2861024 v 1.0</option>

								<option value="67856186-E4DE-9796-E040-BB89AD430CFD">
									caSeer_caBIG - caBIG- 2861003 v 1.0</option>

								<option value="F37FF76C-D8BF-28C2-E034-0003BA3F9857">
									Catalogue of Published Forms - caBIG- 2208181 v 1.0</option>

								<option value="FE257E28-5580-3001-E034-0003BA3F9857">
									caTIES 1.0 - caBIG- 2388918 v 1.0</option>

								<option value="11A4A8B2-3FEC-2163-E044-0003BA3F9857">
									caTIES 2.0 - caBIG- 2475251 v 2.0</option>

								<option value="212022B3-5551-2E96-E044-0003BA3F9857">
									caTISSUE CAE - caBIG- 2534075 v 1.2</option>

								<option value="1B8B2CD6-830D-0325-E044-0003BA3F9857">
									caTISSUE Core - caBIG- 2513254 v 1.0</option>

								<option value="2483C38A-B1C5-3C9A-E044-0003BA3F9857">
									caTissue_Core - caBIG- 2553133 v 1.1</option>

								<option value="39F2F850-17B8-33F4-E044-0003BA3F9857">
									caTissue_Core_1_2 - caBIG- 2680967 v 1.2</option>

								<option value="344EA9C6-3250-1CD8-E044-0003BA3F9857">
									caTissue_Core_caArray - caBIG- 2661745 v 1.0</option>

								<option value="5690A20B-FEC2-3400-E044-0003BA3F9857">
									caTissue_Suite - caBIG- 2782636 v 1.0</option>

								<option value="6ED3E0DA-4286-C487-E040-BB89AD4324C5">
									caTissue_Suite1_1 - caBIG- 2919341 v 1.1</option>

								<option value="8F359610-6FDF-B876-E040-BB89AD435682">
									caTissue_Suite1_2 - caBIG- 2919341 v 1.2</option>

								<option value="249802CB-36C7-5565-E044-0003BA3F9857">
									caTRIP Annotation Engine - caBIG- 2553954 v 1.0</option>

								<option value="249AD332-65A9-70EA-E044-0003BA3F9857">
									caTRIP Tumor Registry - caBIG- 2554136 v 1.0</option>

								<option value="5315FC16-D6CB-526C-E044-0003BA3F9857">
									caXchange - caBIG- 2768653 v 1.0</option>

								<option value="E7EB89DA-4257-0BCF-E034-0003BA3F9857">
									cc - TEST- 2190840 v 1.0</option>

								<option value="D1D6C2B2-984A-2C7E-E034-0003BA12F5E7">
									CCR Common Data Element Collection - CCR- 2857168 v 1.0</option>

								<option value="D68D0E3F-468F-057B-E034-0003BA12F5E7">
									CCR Implementation - CCR- 2182125 v 1.0</option>

								<option value="46A9AFB5-9B20-68B0-E044-0003BA3F9857">
									CDC NCPHI Proof of Concept - caBIG- 2730636 v .1</option>

								<option value="F9FF390E-15C6-5593-E034-0003BA3F9857">
									CDISC Codelists - CDISC- 2857174 v 1.0</option>

								<option value="C6F03666-76F9-52D0-E040-BB89AD4355A8">
									CEM - TEST- 3553732 v 1.0</option>

								<option value="5C0C4BB5-415B-3885-E044-0003BA3F9857">
									Center for Epidemiologic Studies Depression Scale (CES-D) -
									caBIG- 2802549 v 1.0</option>

								<option value="5C0D7984-A136-0873-E044-0003BA3F9857">
									Center for Epidemiologic Studies Depression Scale_CESD - PS&CC-
									2802722 v 1.0</option>

								<option value="3D304306-8CEE-095F-E044-0003BA3F9857">
									Centers for Disease Control and Prevention - TEST- 2691302 v
									1.0</option>

								<option value="651A0201-F59A-AF2F-E040-BB89AD434AC6">
									CGWB - caBIG- 2611721 v 2.0</option>

								<option value="2B91922A-9C6F-022B-E044-0003BA3F9857">
									CGWB - caBIG- 2611721 v 1.0</option>

								<option value="4E5E6DF6-A47B-34DE-E044-0003BA3F9857">
									ChemBank - caBIG- 2714463 v 1.1</option>

								<option value="41434C42-9A0C-31E8-E044-0003BA3F9857">
									ChemBank - caBIG- 2714463 v 1.0</option>

								<option value="78AB4020-2825-3CC6-E040-BB89AD43314C">
									Children's Oncology Group (COG) - CTEP- 2961451 v 1.0</option>

								<option value="62C0F5C1-5916-D178-E040-BB89AD43393D">
									Chromosomal Segment Overlap Finder Across Samples - caBIG-
									2839207 v 1.0</option>

								<option value="65F8D6A4-A193-D609-E040-BB89AD43414B">
									Chromosomal Segment Overlap Finder Across Sources - caBIG-
									2856819 v 1.0</option>

								<option value="A14B2229-AE1A-322A-E040-BB89AD434258">
									CHTN (Cooperative Human Tissue Network) - caBIG- 3228240 v 1.0
								</option>

								<option value="2998D7F8-6442-46C5-E044-0003BA3F9857">
									Clinic(NCDE) - caBIG- 2597548 v 1.0</option>

								<option value="D9377D6E-D8A6-6CFB-E034-0003BA12F5E7">
									Clinical Trial Mgmt Systems - caBIG- 2183535 v 1.0</option>

								<option value="24E61073-400D-3870-E044-0003BA3F9857">
									Clinical Trials Lab Model - caBIG- 2555333 v .5</option>

								<option value="46E7CAB2-6472-239B-E044-0003BA3F9857">
									Clinical Trials Lab Model - caBIG- 2555333 v 1.0</option>

								<option value="4463AB3C-2082-2D1B-E044-0003BA3F9857">
									Clinical Trials Object Data System (CTODS) - caBIG- 2724612 v
									.53</option>

								<option value="39788B74-7087-0600-E044-0003BA3F9857">
									CoCaNUT - caBIG- 2677906 v 1.0</option>

								<option value="F4CFF24F-4C69-0D5C-E034-0003BA3F9857">
									Commercial Partners - caBIG- 2857170 v 1.0</option>

								<option value="9EB47A86-9D82-C9FE-E040-BB89AD437EAE">
									Common Biorepository Model - caBIG- 3204728 v 1.0</option>

								<option value="77FA9AFF-271A-F43C-E040-BB89AD4365E6">
									COPPA - caBIG- 2958963 v 1.0</option>

								<option value="5EB9AD11-532D-8B81-E040-BB89AD435C72">
									Copy Number Analysis Tool - caBIG- 2819751 v 1.0</option>

								<option value="99BA9DC8-A61F-4E69-E034-080020C9C0E0">
									CRF Disease - CTEP- 2857165 v 2.31</option>

								<option value="99BA9DC8-A620-4E69-E034-080020C9C0E0">
									CRF Trial Type Usage - CTEP- 2857166 v 2.31</option>

								<option value="A8253E60-3997-3059-E040-BB89AD433359">
									CSTE Position Statements - CDC/PHIN- 3253737 v 1.0</option>

								<option value="8B4B1C30-1935-EFC9-E040-BB89AD43698F">
									CTCAE v4.0 CDEs - caBIG- 3121334 v 1.0</option>

								<option value="29ECA152-26ED-2C05-E044-0003BA3F9857">
									CTEP CDS Data Elements - caBIG- 2598198 v 1.0</option>

								<option value="7D0391C9-D7B9-81FD-E040-BB89AD434ADC">
									CTEP Enterprise Services - caBIG- 2985612 v 2.2</option>

								<option value="17618EC8-84AE-514D-E044-0003BA3F9857">
									CTMS Metadata Project - caBIG- 2493167 v 1.0</option>

								<option value="2B909EC9-D07B-0528-E044-0003BA3F9857">
									CTOM (Clinical Trials Object Model) - caBIG- 2611677 v 1.0</option>

								<option value="3D665840-A2F3-2AEC-E044-0003BA3F9857">
									Data Brokering - TEST- 2691539 v 1.0</option>

								<option value="3D664C39-6E77-2BDB-E044-0003BA3F9857">
									Data Provisioning - TEST- 2691534 v 1.0</option>

								<option value="E92962A2-9978-1F46-E034-0003BA3F9857">
									Data Standards - caBIG- 2192345 v 1.0</option>

								<option value="3D665F27-F127-2AA6-E044-0003BA3F9857">
									Data Warehouse - TEST- 2691541 v 1.0</option>

								<option value="1695FC8B-EB7D-06E2-E044-0003BA3F9857">
									DCP Enterprise System Knowledgebase - DCP- 2487057 v 1.0</option>

								<option value="7338523B-B873-D6D7-E040-BB89AD432986">
									DCTD (Division of Cancer Treatment and Diagnosis) - caBIG-
									2939361 v 1.0</option>

								<option value="23F76C14-9A28-5EC7-E044-0003BA3F9857">
									Death Test - NHLBI- 2550736 v 1.0</option>

								<option value="E7EA9A59-C014-016E-E034-0003BA3F9857">
									Demonstration Applications - caBIG- 2190530 v 1.0</option>

								<option value="49D12FB5-97B0-5A3A-E044-0003BA3F9857">
									DemoService - caBIG- 2738503 v 1.0</option>

								<option value="90D1856B-44C2-9D5D-E040-BB89AD43637F">
									Denise Test CS - TEST- 3140556 v 1.0</option>

								<option value="1400A872-A0DA-7132-E044-0003BA3F9857">
									DHS - Training- 2482123 v 1.0</option>

								<option value="2C39F3F3-CB9E-008E-E044-0003BA3F9857">
									DICOM - caBIG- 2614826 v 1.0</option>

								<option value="57881B62-3308-0CF7-E044-0003BA3F9857">
									DigitalModelRepository(DMR) - caBIG- 2786997 v 1.0</option>

								<option value="CCE1AFFB-9A3E-4007-E034-0003BA12F5E7">
									DIRECTOR'S CHALLENGE LUNG STUDY - caCORE- 2178524 v 1.0</option>

								<option value="C454EB93-B4C4-2AC1-E034-0003BA12F5E7">
									Director's Challenge Lung Study Forms - caBIG- 2008609 v 1.0</option>

								<option value="36AA6EB9-609C-3C96-E044-0003BA3F9857">
									Disease Relapse - NHLBI- 2670694 v 1.0</option>

								<option value="B2E4B318-165D-6842-E040-BB89AD433EE7">
									Disease Site - ACRIN- 3314438 v 1.0</option>

								<option value="EAC04669-6844-08FD-E034-0003BA3F9857">
									Division of Cancer Control and Population Sciences - PS&CC-
									2193114 v 1.0</option>

								<option value="EAC02A7D-CA3E-0786-E034-0003BA3F9857">
									Division of Cancer Epidemiology and Genetics - PS&CC- 2193113 v
									1.0</option>

								<option value="61190DC4-842B-EB2F-E040-BB89AD4322AE">
									DNA Copy Analytical Service - caBIG- 2828532 v 1.0</option>

								<option value="2C3B6725-886D-6BAD-E044-0003BA3F9857">
									DSD - caBIG- 2614835 v 1.0</option>

								<option value="CAC5DFEB-D7D8-7221-E034-0003BA12F5E7">
									Electrocardiography Evaluation - CCR- 2008610 v 1.0</option>

								<option value="7832CF25-698C-938F-E040-BB89AD437680">
									Eligibility Criteria - TEST- 2960572 v 1.0</option>

								<option value="79DA1332-08D2-1C29-E040-BB89AD431C86">
									Eligibility Criteria - caBIG- 2964591 v 1.0</option>

								<option value="7ECA45CE-43FA-2404-E040-BB89AD435E3B">
									eMERGE - caBIG- 3006612 v 1.0</option>

								<option value="C64A9970-3E63-FB3F-E040-BB89AD4348C8">
									EQ-5D-5L (EuroQol Group EQ-5D Health Questionnaire) - caBIG-
									3539833 v 1.0</option>

								<option value="3D665840-A305-2AEC-E044-0003BA3F9857">
									ETL - TEST- 2691540 v 1.0</option>

								<option value="219A3326-3FEE-5733-E044-0003BA3F9857">
									EVS Core Grid Analytical Service - caBIG- 2538651 v 1.0</option>

								<option value="917A8C65-F3EC-F3ED-E040-BB89AD430C19">
									FACT G - TEST- 3144217 v 1.0</option>

								<option value="B8520546-F51E-B2FA-E040-BB89AD43683B">
									FAHI (Functional Assessment of HIV Infection) - caBIG- 3370903
									v 1.0</option>

								<option value="21C01641-8A30-4E13-E044-0003BA3F9857">
									Family Blood Pressure Program - NHLBI- 2539469 v 1.0</option>

								<option value="3C3CE8E7-69FE-49CB-E044-0003BA3F9857">
									Form 2100 Review - NHLBI- 2688829 v 1.0</option>

								<option value="EABAEBEA-4231-287B-E034-0003BA3F9857">
									Forms-based Training Materials - Training- 2193046 v 1.0</option>

								<option value="917C23FD-2D4B-38B7-E040-BB89AD430D18">
									Functional Assessment of Cancer Therapy General (FACT-G) -
									PS&CC- 3144420 v 1.0</option>

								<option value="BD8F4A9E-1F44-297B-E040-BB89AD4376DE">
									GBC (Group Banking Committee) - caBIG- 3436920 v 1.0</option>

								<option value="65BFB1C9-C577-79CA-E040-BB89AD436EC2">
									Gene Pattern - caBIG- 2854841 v 1.0</option>

								<option value="22B29449-5512-2568-E044-0003BA3F9857">
									GeneConnect - caBIG- 2544880 v 1.0</option>

								<option value="65C12680-E226-EBB8-E040-BB89AD433C9C">
									GeneNeighbors - caBIG- 2854844 v 1.0</option>

								<option value="2CBF962E-9D29-5B64-E044-0003BA3F9857">
									GenePattern - caBIG- 2620091 v 1.0</option>

								<option value="5C751804-48C5-5445-E044-0003BA3F9857">
									GenePattern Based Copy Number Analytical Service - caBIG-
									2804620 v 1.0</option>

								<option value="8FAC7394-3767-C58E-E040-BB89AD43636D">
									General CDEs - NINDS- 3134868 v 1.0</option>

								<option value="2C3B0F02-4214-6BE7-E044-0003BA3F9857">
									Generic Image - caBIG- 2614836 v 1.0</option>

								<option value="4EAD8B6B-FE13-1740-E044-0003BA3F9857">
									Generic Parameters - caBIG- 2754761 v 1.0</option>

								<option value="FD5EC301-9FA9-2166-E034-0003BA3F9857">
									Genomic Identifiers - caBIG- 2857177 v 1.0</option>

								<option value="24FC3036-3B12-2266-E044-0003BA3F9857">
									geworkbench - caBIG- 2557741 v 1.0</option>

								<option value="616A263F-3ED4-F47A-E040-BB89AD437105">
									geworkbench - caBIG- 2557741 v 1.1</option>

								<option value="D07DDA06-FD82-71C0-E034-0003BA12F5E7">
									GF4057 Test (production) - TEST- 2180031 v 1.0</option>

								<option value="3D6665F4-1B1E-280C-E044-0003BA3F9857">
									GIS Data - TEST- 2691544 v 1.0</option>

								<option value="7C6C05EF-5417-F6C9-E040-BB89AD437BC9">
									GO Trial - SPOREs- 2976812 v 1.0</option>

								<option value="1E4C5288-D26D-2423-E044-0003BA3F9857">
									GoMiner - caBIG- 2521476 v 1.0</option>

								<option value="76631E99-6536-3DFD-E040-BB89AD43281D">
									GRANITE - caBIG- 2954884 v 1.0</option>

								<option value="7CDCC466-E0B5-C007-E040-BB89AD4314D2">
									Grid Enabled Measures - PS&CC- 2983752 v 1.0</option>

								<option value="9ADB907E-66C0-8BA6-E040-BB89AD433D13">
									Grid Enabled Measures caBIG - TEST- 3187531 v 1.0</option>

								<option value="FD97AB82-5E9F-5244-E034-0003BA3F9857">
									Grid-enablement of Protein Information Resource (PIR) 1.0 -
									caBIG- 2857178 v 1.0</option>

								<option value="18CA2FF1-DE58-696E-E044-0003BA3F9857">
									Grid-enablement of Protein Information Resource (PIR) 1.1 -
									caBIG- 2496586 v 1.1</option>

								<option value="41CD1D4F-DD3E-66F7-E044-0003BA3F9857">
									Grid-enablement of Protein Information Resource (PIR) 1.2 -
									caBIG- 2716603 v 1.2</option>

								<option value="97EDEC71-AF62-D9E9-E040-BB89AD4355DF">
									gridTCR - caBIG- 3173038 v 1.0</option>

								<option value="F2487E76-55E9-519D-E034-0003BA3F9857">
									Head and Neck SPOREs - SPOREs- 2201036 v 1.0</option>

								<option value="2998F214-C864-4623-E044-0003BA3F9857">
									Health(NCDE) - caBIG- 2597552 v 1.0</option>

								<option value="D6F34A94-A3E4-257B-E034-0003BA12F5E7">
									Hierarchical Disease Classification Scheme - CTEP- 2182337 v
									1.0</option>

								<option value="81DA8C19-BF25-3AED-E040-BB89AD4371AE">
									HINTS 2005 - caBIG- 3024952 v 1.0</option>

								<option value="8225B1C6-407A-E0B5-E040-BB89AD43301D">
									HINTS2005 - PS&CC- 3028392 v 1.0</option>

								<option value="501DFC4A-4831-33BF-E044-0003BA3F9857">
									HINTSSurvey - PS&CC- 2760571 v 1.0</option>

								<option value="410A6124-639E-0748-E044-0003BA3F9857">
									HITSP Value Sets - HITSP- 2713346 v 1.0</option>

								<option value="3D304306-8D00-095F-E044-0003BA3F9857">
									HL7 2.3 Message Segments - TEST- 2691303 v 1.0</option>

								<option value="FF05CFCC-C742-6A13-E034-0003BA3F9857">
									Homework Examples - Training- 2857179 v 1.0</option>

								<option value="B43CA6A7-0CA6-E2C8-E040-BB89AD437042">
									HTMCP (HIV+ Tumor Molecular Characterization Project) - caBIG-
									3335152 v 1.0</option>

								<option value="23A44EA9-4362-5F02-E044-0003BA3F9857">
									I-SPY - caBIG- 2548333 v 1.0</option>

								<option value="A44AB420-F6DC-68AC-E040-BB89AD433151">
									IARC Cancer Registry - caBIG- 3241399 v 1.0</option>

								<option value="49D09A48-20EE-58DC-E044-0003BA3F9857">
									ICR-ASBP - caBIG- 2738543 v 1.0</option>

								<option value="70CCA8BF-F5A5-3D39-E040-BB89AD430C28">
									Iloprost Trial - SPOREs- 2931931 v 1.0</option>

								<option value="CDD8DCF2-03F3-4640-E040-BB89AD433DB9">
									Image Finding CS - ACRIN- 3625128 v 1.0</option>

								<option value="6C028645-0BC4-FD9E-E040-BB89AD430509">
									ImageMiner - caBIG- 2899621 v 1.0</option>

								<option value="2C347552-86FC-2F51-E044-0003BA3F9857">
									Imaging - caBIG- 2614746 v 1.0</option>

								<option value="B2E4B8E8-E9C5-8817-E040-BB89AD435009">
									Imaging Modality - ACRIN- 3314439 v 1.0</option>

								<option value="1D482B58-B132-472A-E044-0003BA3F9857">
									Imaging-Old - caBIG- 2519225 v 1.0</option>

								<option value="FA128453-4517-39D1-E034-0003BA3F9857">
									In-class Examples - Training- 2238378 v 1.0</option>

								<option value="3F62BAF1-E324-141B-E044-0003BA3F9857">
									Infusion form for Review - NHLBI- 2697804 v 1.0</option>

								<option value="D935BF6E-7689-5FB7-E034-0003BA12F5E7">
									Integrative Cancer Research - caBIG- 2183534 v 1.0</option>

								<option value="A4AB02C0-0323-9FE9-E040-BB89AD43032D">
									IPq-USP - caBIG- 3242017 v 1.0</option>

								<option value="B6CEC63D-6234-1200-E040-BB89AD432D4E">
									ISA-TAB-Nano - caBIG- 3354861 v 1.0</option>

								<option value="70868A15-09A9-230D-E040-BB89AD43658F">
									ISO21090v1_0 - caBIG- 2928087 v 1.0</option>

								<option value="4C7EF2AE-3190-5AAB-E044-0003BA3F9857">
									Jamie's Training - TEST- 2746709 v 1.0</option>

								<option value="ADC70088-B37A-058B-E034-0003BA12F5E7">
									JAVA PACKAGES - caCORE- 2857167 v 1.0</option>

								<option value="1851CC7D-4998-3119-E044-0003BA3F9857">
									Jennys Project Metadata - Training- 2495057 v 1.0</option>

								<option value="9D6F0E6D-D259-303A-E040-BB89AD430E57">
									KAI Research - caBIG- 3194026 v 1.0</option>

								<option value="67FDD957-32C3-BD6D-E040-BB89AD433B80">
									KNearestNeighbors - caBIG- 2861601 v 1.0</option>

								<option value="30FEB4DD-2E14-3FB6-E044-0003BA3F9857">
									LabKey CPAS Client API - caBIG- 2640373 v 2.1</option>

								<option value="642A211F-73B9-4CAC-E040-BB89AD434DB4">
									Labs - NHLBI- 2842777 v 1.0</option>

								<option value="79D9F703-0C23-8ACC-E040-BB89AD431FE8">
									LabViewer - caBIG- 2964508 v 2.0</option>

								<option value="78BE2413-3858-63F5-E040-BB89AD432AA8">
									LexBIG - caBIG- 2962162 v 1.0</option>

								<option value="49BA9494-989D-6F79-E044-0003BA3F9857">
									LexBIG - caBIG- 2737760 v 2.2</option>

								<option value="5833F603-0197-51C1-E044-0003BA3F9857">
									LexBIG 2.3 - caBIG- 2737760 v 2.3</option>

								<option value="7C807E4E-28B1-49EE-E040-BB89AD436031">
									LexEVS - caBIG- 2979232 v 1.0</option>

								<option value="7C8A769A-6A73-CF6F-E040-BB89AD434196">
									LexEVS 5.0 - caBIG- 2981932 v 5.0</option>

								<option value="97F70A5F-E608-9041-E040-BB89AD4377F6">
									Link to BRIDG 3.0.2 Model - BRIDG- 3177537 v 1.0</option>

								<option value="6BDC9F47-DC77-749B-E040-BB89AD4365E6">
									Link to caBIG CDE Standards - caBIG CDE Data Standards- 2899264
									v 1.0</option>

								<option value="69709767-AAD7-F28F-E040-BB89AD4334AE">
									Link to the BRIDG 2.1 Model - BRIDG- 2873983 v 1.0</option>

								<option value="68C9FE78-4790-0DFB-E040-BB89AD430823">
									LinkageX - caBIG- 2866531 v 1.0</option>

								<option value="D316AB92-E790-29D7-E034-0003BA12F5E7">
									Lung Image Database Consortium - CIP- 2180933 v 1.0</option>

								<option value="78AF584A-52B2-C038-E040-BB89AD4364A1">
									lungspore - caBIG- 2961512 v 1.1</option>

								<option value="4DDE44AC-CE2F-6D0D-E044-0003BA3F9857">
									Lymphoma Enterprise Architecture Data System (LEADS) - caBIG-
									2751669 v 1.0</option>

								<option value="CE757C66-BD2E-8D6C-E040-BB89AD431965">
									MBSRQ Appearance_Multidimensional Body Self-Relations
									Questionnaire-Appearance Scale - caBIG- 3626264 v 1.0</option>

								<option value="5675D30D-6073-22AD-E044-0003BA3F9857">
									MDR - caCORE- 2780868 v 1.0</option>

								<option value="9815F126-8C6C-E60B-E040-BB89AD431357">
									Measures - PS&CC- 3178240 v 1.0</option>

								<option value="B906F5E5-A1AE-66AF-E040-BB89AD436C96">
									Measures - caBIG- 3378854 v 1.0</option>

								<option value="B3656B93-4868-71F4-E034-0003BA12F5E7">
									Medical Imaging - CIP- 2008605 v 1.0</option>

								<option value="3D664058-4EAF-2AC3-E044-0003BA3F9857">
									Messaging Guide 1.5 - TEST- 2691530 v 1.0</option>

								<option value="F9FC3B4E-B405-3659-E034-0003BA3F9857">
									MicroArray Gene Expression Object Model (Mage-OM) - caCORE-
									2321254 v 1.0</option>

								<option value="2C39EBBF-50F0-6BAF-E044-0003BA3F9857">
									Middleware - caBIG- 2614827 v 1.0</option>

								<option value="CA749692-09EB-D206-E040-BB89AD435748">
									Miraca Life Sciences - caBIG- 3595692 v 1.0</option>

								<option value="27CC431E-E589-0162-E044-0003BA3F9857">
									My Test Container - TEST- 2590625 v 1.0</option>

								<option value="3BC509E8-3F46-4361-E044-0003BA3F9857">
									My Training Project - Training- 2686022 v 1.0</option>

								<option value="1045E1FE-90AA-23B2-E044-0003BA3F9857">
									MySubtractionService - TEST- 2467349 v 1.0</option>

								<option value="74543FAA-28B4-5762-E040-BB89AD4374F6">
									NBIA (National Biomedical Imaging Archive) - caBIG- 2944977 v
									5.0</option>

								<option value="C52F84D5-2AC4-F1FC-E040-BB89AD430D6D">
									NCCCP (NCI Community Cancer Centers Program) - caBIG- 3533741 v
									1.0</option>

								<option value="A895A19B-0399-702A-E034-0003BA12F5E7">
									NCI Concept Hierarchy - SPOREs- 2008596 v 1.0</option>

								<option value="1E77EFD6-BDF1-4E0D-E044-0003BA3F9857">
									NCI-60 Drug - caBIG- 2523380 v 1.0</option>

								<option value="1E82841B-EDAD-3F6F-E044-0003BA3F9857">
									NCI-60 SKY - caBIG- 2523764 v 1.0</option>

								<option value="022BCB01-89D8-69EE-E044-0003BA3F9857">
									NCIA (National Cancer Imaging Archive) - CIP- 2857181 v 1.0</option>

								<option value="249586AC-6595-3B4C-E044-0003BA3F9857">
									NCIA (National Cancer Imaging Archive)2.0 - CIP- 2553603 v 1.0
								</option>

								<option value="2C39F9A3-0851-028C-E044-0003BA3F9857">
									NCIA Collection - caBIG- 2614828 v 1.0</option>

								<option value="2C39EDFD-2446-0216-E044-0003BA3F9857">
									NCIA Model Archived - caBIG- 2614829 v 1.0</option>

								<option value="3E358799-3276-0308-E044-0003BA3F9857">
									NCIA_Model - caBIG- 2693115 v 3.0</option>

								<option value="AB53CB3E-4BD3-58A3-E034-0003BA12F5E7">
									NCI_CORE - caCORE- 2008598 v 1.0</option>

								<option value="D67A777E-B339-2064-E034-0003BA12F5E7">
									net-Trials - CCR- 2182094 v 1.0</option>

								<option value="B83ACEE0-DCE7-130B-E034-0003BA12F5E7">
									NEUROBLASTOMA - CTEP- 2008607 v 1.0</option>

								<option value="D10B6B47-CAEC-19B8-E034-0003BA12F5E7">
									New CDEs per study - SPOREs- 2180156 v 1.0</option>

								<option value="3ED2629B-C2B9-4D8A-E044-0003BA3F9857">
									New Content Jenni Bloomquist - NHLBI- 2695312 v 1.0</option>

								<option value="3A05A166-7ECA-0C7C-E044-0003BA3F9857">
									New Content Robinette Aley - NHLBI- 2681512 v 1.0</option>

								<option value="3A05918F-A1E4-0E2F-E044-0003BA3F9857">
									New Content Thomas Joshua - NHLBI- 2681516 v 1.0</option>

								<option value="3ED26524-59CE-498F-E044-0003BA3F9857">
									New Content Wendy Zhang - NHLBI- 2695314 v 1.0</option>

								<option value="6B9EBC15-BEED-26C8-E040-BB89AD4354A8">
									New Example - TEST- 2898456 v 1.0</option>

								<option value="77A5DF88-50B8-831F-E040-BB89AD435A5B">
									Newborn Examination - caBIG- 2958247 v 1.0</option>

								<option value="77A6D5CB-8314-C935-E040-BB89AD432349">
									NewbornExamination - NICHD- 2958652 v 1.0</option>

								<option value="875B020C-B7CB-6A2E-E040-BB89AD431696">
									NHIS2005 - PS&CC- 3098928 v 1.0</option>

								<option value="85B4C3DB-42BB-6570-E040-BB89AD4302D7">
									NHIS_2005 - caBIG- 3081758 v 1.0</option>

								<option value="40A4AACD-C299-4508-E044-0003BA3F9857">
									NHLBI - caBIG- 2710221 v 1.0</option>

								<option value="9BBECC8A-4762-6055-E040-BB89AD4323D9">
									NHS National Cancer Dataset (United Kingdom) - caBIG- 3190118 v
									1.0</option>

								<option value="A881AA61-7807-7A88-E040-BB89AD4347DA">
									NIDA Substance Abuse EHR - NIDA- 3254040 v 1.0</option>

								<option value="3ED27E7F-3CBB-654A-E044-0003BA3F9857">
									NMDP: CDEs to review - NHLBI- 2695319 v 1.0</option>

								<option value="2998CD52-3F44-4631-E044-0003BA3F9857">
									Nordic Common Data Elements (NCDE) - caBIG- 2597546 v 1.0</option>

								<option value="8F5DAB72-C600-78E7-E040-BB89AD434CE3">
									North American Association of Cancer Registries - caBIG-
									3134705 v 1.0</option>

								<option value="B127B061-34CA-5615-E034-0003BA12F5E7">
									NOS - CTEP- 2008600 v 1.0</option>

								<option value="53D109EF-5847-44BF-E044-0003BA3F9857">
									Novartis - caBIG- 2770367 v 1.0</option>

								<option value="B9991BBD-DC5F-70B5-E040-BB89AD431835">
									OHIP-14 (Oral Health Impact Profile) - caBIG- 3384631 v 1.0</option>

								<option value="62C01FBB-9850-3855-E040-BB89AD435165">
									omniBiomarker - caBIG- 2839153 v 1.0</option>

								<option value="7BF5C3DC-1739-04F2-E040-BB89AD4334C7">
									omniSpect - caBIG- 2975196 v 1.0</option>

								<option value="BA310152-F943-567C-E040-BB89AD437D12">
									OMRS (Oral Mucositis Rating Scale) - caBIG- 3396662 v 1.0</option>

								<option value="4323767E-9F76-2531-E044-0003BA3F9857">
									ONS (Oncology Nursing Society) - caBIG- 2718902 v 1.0</option>

								<option value="B67065CE-376E-B1F6-E040-BB89AD43205E">
									OPEN to Rave Standard Forms - CTEP- 3351909 v 1.0</option>

								<option value="B6D4370D-6C39-F05E-E040-BB89AD431103">
									OPEN to Rave Template Forms - CTEP- 3357378 v 1.0</option>

								<option value="27F99F5E-A087-086F-E044-0003BA3F9857">
									Organism Identification - caBIG- 2590783 v 1.0</option>

								<option value="A1FDDE27-DCB1-5F08-E040-BB89AD43363B">
									Parkinson's Disease CDEs - NINDS- 3232477 v 1.0</option>

								<option value="3CB0F136-3A24-113C-E044-0003BA3F9857">
									PathwayInteractionDatabase - caBIG- 2689825 v 1.0</option>

								<option value="D0CF4498-8DFD-3311-E034-0003BA12F5E7">
									PATIENT INFORMATION CHARACTERISTICS - CIP- 2180102 v 1.0</option>

								<option value="A2CE5CB3-28FA-58C1-E040-BB89AD437AA6">
									Patient Outcomes Data System (PODS) - caBIG- 3234177 v 1.0</option>

								<option value="66FAF425-D574-AA1B-E040-BB89AD4370E4">
									Patient Study Calendar - caBIG- 2672769 v 2.1</option>

								<option value="7A174491-4FD4-6567-E040-BB89AD4351E8">
									Patient Study Calendar - caBIG- 2672769 v 2.6</option>

								<option value="37D10239-C9BD-56B9-E044-0003BA3F9857">
									Patient Study Calendar - caBIG- 2672769 v 1.0</option>

								<option value="478930AA-C2B6-1A34-E044-0003BA3F9857">
									Patient Study Calendar - caBIG- 2672769 v 2.0</option>

								<option value="6C038498-7BDD-EFA4-E040-BB89AD433665">
									PCTA - caBIG- 2900334 v 1.0</option>

								<option value="A2168F7B-2773-20D2-E040-BB89AD434757">
									PEARL - NIDCR- 3232581 v 1.0</option>

								<option value="A214F079-6855-4F54-E040-BB89AD433E19">
									PEARL 0602 - TEST- 3232567 v 1.0</option>

								<option value="77A5D320-3471-52AA-E040-BB89AD4343F1">
									Pediatrics - NICHD- 2958244 v 1.0</option>

								<option value="C96DCE14-1F78-78D6-E040-BB89AD43038A">
									Pediatrics Critical Care - NICHD- 3588366 v 1.0</option>

								<option value="6FF18E8E-53F7-7CCF-E040-BB89AD43659C">
									PeptideAtlas - caBIG- 2926008 v 1.0</option>

								<option value="A15ED698-ECFE-4715-E040-BB89AD436346">
									Perceived Stress Scale - TEST- 3228346 v 1.0</option>

								<option value="A1FC9152-558F-6756-E040-BB89AD436D55">
									PerceivedStressScale_PSS - PS&CC- 3232464 v 1.0</option>

								<option value="FFA539F2-7304-3072-E034-0003BA3F9857">
									Person - Training- 2400281 v 1.0</option>

								<option value="D1D6C2B2-9846-2C7E-E034-0003BA12F5E7">
									PHARMACOKINETICS - CCR- 2180420 v 1.0</option>

								<option value="BFED25EE-BED4-0E4B-E034-0003BA12F5E7">
									Phase - CTEP- 2008608 v 1.0</option>

								<option value="58D76DCF-7606-1D61-E044-0003BA3F9857">
									PhenX - caBIG- 2793652 v 1.0</option>

								<option value="3D665840-A2E1-2AEC-E044-0003BA3F9857">
									PHINMS Receiver - TEST- 2691538 v 1.0</option>

								<option value="3D6647E5-91E2-2B9F-E044-0003BA3F9857">
									PHINMS Sender - TEST- 2691537 v 1.0</option>

								<option value="C96DEB43-267F-7C99-E040-BB89AD433E77">
									PICUcoreClinicalData - NICHD- 3588382 v 1.0</option>

								<option value="3D2F9945-9FF2-192C-E044-0003BA3F9857">
									PID - Patient Identification Segment - TEST- 2691304 v 1.0</option>

								<option value="037F3DE0-1A82-1EFA-E044-0003BA3F9857">
									Potential CDEs for Reuse - NIDCR- 2857184 v 1.0</option>

								<option value="1B8A6942-75CA-2403-E044-0003BA3F9857">
									Potential CDEs for Reuse - NHLBI- 2512690 v 1.0</option>

								<option value="65C0361F-7C14-2240-E040-BB89AD431CA4">
									PrincipalComponentsAnalysis - caBIG- 2854842 v 2.0</option>

								<option value="A215678D-DAF0-9DD3-E040-BB89AD4379BA">
									PRL0602 - NIDCR- 3232580 v 1.0</option>

								<option value="02F2935A-463B-3E3C-E044-0003BA3F9857">
									ProteomicsLIMS - caBIG- 2857183 v 1.0</option>

								<option value="627FDD44-CD17-9F42-E040-BB89AD437F61">
									protExpress - caBIG- 2837741 v 1.0</option>

								<option value="F560B208-65CA-65E1-E034-0003BA3F9857">
									Protocol Amendment - CCR- 2857171 v 1.0</option>

								<option value="F560C6FF-EE8A-66BB-E034-0003BA3F9857">
									Protocol Epoch - CCR- 2220736 v 1.0</option>

								<option value="02F0A112-DE0B-45A4-E044-0003BA3F9857">
									Protocol Forms - NIDCR- 2857182 v 1.0</option>

								<option value="B2E62D84-DBC7-989A-E040-BB89AD431F5E">
									Protocols - ACRIN- 3314563 v 1.0</option>

								<option value="A703AB38-CE67-188D-E034-0003BA0B1A09">
									Public Health Conceptual Data Model - SPOREs- 2008595 v 1.0</option>

								<option value="AA15CC22-415B-B44B-E040-BB89AD437B1B">
									Pulse - CDISC- 3260882 v 1.0</option>

								<option value="3D3E3B76-50FC-45E7-E044-0003BA3F9857">
									PV1 - Patient Visit - TEST- 2691387 v 1.0</option>

								<option value="2C3B1EAC-1350-6F2C-E044-0003BA3F9857">
									RadLex - caBIG- 2614831 v 1.0</option>

								<option value="30991C88-88AF-3B5B-E044-0003BA3F9857">
									Reactome Database Sharing - caBIG- 2638539 v 1.0</option>

								<option value="3D664C39-6E89-2BDB-E044-0003BA3F9857">
									Reference Data - TEST- 2691545 v 1.0</option>

								<option value="0FC32A7D-67F5-4259-E044-0003BA3F9857">
									RESERVED FOR SENTINEL MONITOR - caBIG- 2465726 v 1.0</option>

								<option value="2AF1EFCC-2779-628F-E044-0003BA3F9857">
									Retired CTOM (Clinical Trials Object Model) - CDISC- 2607493 v
									1.0</option>

								<option value="04349EA1-83E2-51DB-E044-0003BA3F9857">
									RProteomics - caBIG- 2857185 v 1.0</option>

								<option value="EF7AE597-692F-4F9D-E034-0003BA3F9857">
									SAE Reporting Application - caBIG- 2857169 v 1.0</option>

								<option value="8BDE3C94-9800-F108-E040-BB89AD4308D3">
									Sarcoma Database - caBIG- 3124057 v 1.0</option>

								<option value="FF7FB82E-749B-1278-E034-0003BA3F9857">
									Security Componet - Training- 2399260 v 1.0</option>

								<option value="1D326A80-0853-22C2-E044-0003BA3F9857">
									Seed - caBIG- 2519060 v 1.0</option>

								<option value="5B9D7B49-10A3-58CD-E044-0003BA3F9857">
									SEER 17 caBIG - caBIG- 2800331 v 1.0</option>

								<option value="5B4B74AA-7D97-0B1C-E044-0003BA3F9857">
									SEER Healthy Goals - caBIG- 2798698 v 1.0</option>

								<option value="5C1070FC-2DFC-0A0B-E044-0003BA3F9857">
									SEER Standard Population Statistics - caBIG- 2803148 v 1.0</option>

								<option value="5C0DE41E-D017-5BFF-E044-0003BA3F9857">
									SEER United States Mortality Statistics - caBIG- 2802944 v 1.0
								</option>

								<option value="5C11083C-1917-326D-E044-0003BA3F9857">
									SEER US Population - caBIG- 2803320 v 1.0</option>

								<option value="5B9CB5F0-8108-70DD-E044-0003BA3F9857">
									SEER17 - PS&CC- 2800332 v 1.0</option>

								<option value="5B6F799E-6D0E-0460-E044-0003BA3F9857">
									SEERDemographic - PS&CC- 2799016 v 1.0</option>

								<option value="5B6CE9BD-F7BB-1359-E044-0003BA3F9857">
									SEERDemography - caBIG- 2798952 v 1.0</option>

								<option value="5B5CD23F-22B2-37F7-E044-0003BA3F9857">
									SEERHealthGoals - PS&CC- 2798876 v 1.0</option>

								<option value="5B80D4BE-06FC-6E8F-E044-0003BA3F9857">
									SEERScreening - caBIG- 2799145 v 1.0</option>

								<option value="5B825FF9-0CB2-2F86-E044-0003BA3F9857">
									SEERScreeningStats - PS&CC- 2799194 v 1.0</option>

								<option value="5C0FBF2E-DBDF-1FD3-E044-0003BA3F9857">
									SEERStandardPopulation - PS&CC- 2803194 v 1.0</option>

								<option value="5C0F6D10-BBAB-2008-E044-0003BA3F9857">
									SEERUSMortality - PS&CC- 2803049 v 1.0</option>

								<option value="5C1864C7-F051-5DF5-E044-0003BA3F9857">
									SEERUSPopulation - PS&CC- 2803489 v 1.0</option>

								<option value="5B97D21A-2DD3-49BB-E044-0003BA3F9857">
									SEER_17 - caBIG- 2800181 v 1.0</option>

								<option value="DACB3B23-660D-717E-E034-0003BA12F5E7">
									Site Usage - caBIG- 2183783 v 1.0</option>

								<option value="6B63E1F2-8254-06EE-E040-BB89AD4314D1">
									SNP Microarray Analytical Service - caBIG- 2897009 v 1.0</option>

								<option value="047058DB-A25F-5C38-E044-0003BA3F9857">
									SNP500Cancer - TEST- 2857186 v 1.0</option>

								<option value="C013E8AC-ADC2-731A-E040-BB89AD431F46">
									Staging - caBIG- 3461150 v 1.0</option>

								<option value="99BA9DC8-84A4-4E69-E034-080020C9C0E0">
									STANDARD FORMS - SPOREs- 2008590 v 2.0</option>

								<option value="9B52CC5A-26A5-50F3-E040-BB89AD431B6E">
									Stroke CDEs - NINDS- 3188337 v 1.0</option>

								<option value="974E1AA2-DB18-663B-E040-BB89AD434AB5">
									Subjective Numeracy Scale - TEST- 3165875 v 1.0</option>

								<option value="9760380E-7952-602C-E040-BB89AD43492E">
									SubjectiveNumeracyScale - PS&CC- 3166177 v 1.0</option>

								<option value="2AB29302-4615-24BE-E044-0003BA3F9857">
									Submission and Reporting - CTEP- 2604617 v 1.0</option>

								<option value="67FE8C9D-67FC-CD32-E040-BB89AD43770E">
									SVM - caBIG- 2861767 v 1.0</option>

								<option value="9BB91F31-25FC-DE6D-E040-BB89AD432878">
									Taiwan Cancer Registry - caBIG- 3190082 v 1.0</option>

								<option value="84AA229E-BF6C-E2F7-E040-BB89AD431818">
									TARGET/CGCI - caBIG- 3070837 v 1.0</option>

								<option value="665A12E8-0D02-866C-E040-BB89AD435EF5">
									Taverna-caGrid - caBIG- 2858220 v 1.0</option>

								<option value="6C135660-DAA2-CBB3-E040-BB89AD4324AD">
									TCGA - caBIG- 2900483 v 1.0</option>

								<option value="7289AE07-8292-8039-E040-BB89AD43340B">
									TCGAPortal - caBIG- 2937835 v 2.0</option>

								<option value="97EF1E38-7D69-85E0-E040-BB89AD4345F1">
									TCR - caBIG- 3173877 v 1.0</option>

								<option value="3C256B09-9D2D-318E-E044-0003BA3F9857">
									Test - caBIG- 2688442 v 1.0</option>

								<option value="A93C18E7-6CFB-1A11-E034-0003BA12F5E7">
									TEST - SPOREs- 2008597 v 1.0</option>

								<option value="B39609C0-94D7-6B53-E034-0003BA12F5E7">
									Test CS - TEST- 2008606 v 1.0</option>

								<option value="8B5C7CF7-ACD0-813A-E040-BB89AD430D2C">
									test CS21 - CTEP- 3121567 v 1.0</option>

								<option value="8B60239D-F657-70E2-E040-BB89AD436357">
									Test CS34 - CDISC- 3121676 v 1.0</option>

								<option value="8B60369B-6CC3-52FA-E040-BB89AD437F73">
									TEST CSI 24 - CCR- 3121677 v 1.0</option>

								<option value="DBFD5C7B-E8C9-4BA7-E034-0003BA12F5E7">
									Test Java Packages - TEST- 2184681 v 1.0</option>

								<option value="DD79E800-993C-667F-E034-0003BA12F5E7">
									TEST LOINC Classes - TEST- 2185453 v 1.0</option>

								<option value="B1758F1C-907B-5E04-E034-0003BA12F5E7">
									TEST MIXED CASE TEST_CSCXZC - TEST- 2008604 v 1.0</option>

								<option value="FC6FCCFA-A841-6591-E034-0003BA3F9857">
									TestFolderCS - TEST- 2857176 v 1.0</option>

								<option value="62BFA67D-5E3E-51F2-E040-BB89AD43691E">
									testing a bug in 4001 - TEST- 2839152 v 1.0</option>

								<option value="35009C48-666E-6028-E044-0003BA3F9857">
									Testing caCORE - TEST- 2663837 v 3.2</option>

								<option value="D07CCB25-0871-6D2A-E034-0003BA12F5E7">
									TESTING DENISES CLASSIFICATION SCHEME - CTEP- 2180030 v 1.0</option>

								<option value="D057EE69-9E39-1AB1-E034-0003BA12F5E7">
									TESTING1 - SPOREs- 2179948 v 1.0</option>

								<option value="29A8FB2E-0AB1-11D6-A42F-0010A4C1E842">
									TEST_CSabc - TEST- 2008585 v 1.0</option>

								<option value="4EE9A615-A867-1492-E044-0003BA3F9857">
									The Cancer Genome Atlas - caBIG- 2756809 v 1.0</option>

								<option value="AEA7F9F9-E61E-34DB-E040-BB89AD43081F">
									Theradex - caBIG- 3292694 v 1.0</option>

								<option value="643CA734-5F57-A710-E040-BB89AD437A91">
									Therapy - NHLBI- 2842912 v 1.0</option>

								<option value="F5D190D1-CD09-475E-E034-0003BA3F9857">
									Tissue Bank - SPOREs- 2857172 v 1.0</option>

								<option value="D9368169-CDE6-6DB1-E034-0003BA12F5E7">
									Tissue Banks and Pathology Tools - caBIG- 2183536 v 1.0</option>

								<option value="769C89EB-6187-712C-E040-BB89AD436357">
									Tobacco CDE Inventory - PS&CC- 2955778 v 1.0</option>

								<option value="32BC64C2-524B-5586-E044-0003BA3F9857">
									Tobacco Informatics Grid - PS&CC- 2653801 v 1.0</option>

								<option value="35A54753-EF71-56B4-E044-0003BA3F9857">
									TobaccoInformaticsGrid - PS&CC- 2665304 v 1.0</option>

								<option value="52CD32FD-7E50-5FC4-E044-0003BA3F9857">
									TobaccoTax - PS&CC- 2768607 v 1.0</option>

								<option value="74FAB7E0-A41D-4DD6-E040-BB89AD4349AB">
									TobPRAC - caBIG- 2950470 v 1.0</option>

								<option value="38F07D56-D7B5-267B-E044-0003BA3F9857">
									Training Models - Training- 2676055 v 1.0</option>

								<option value="76F6CB3F-F7C9-C3E1-E040-BB89AD4375A3">
									Transcend - caBIG- 2956164 v 1.0</option>

								<option value="2E553D22-A9F0-0B92-E044-0003BA3F9857">
									Transcription Annotation Prioritization and Screening System -
									caBIG- 2629622 v 1.0</option>

								<option value="9B10247A-65F3-0DD5-E034-080020C9C0E0">
									Trial Type Usages (CDE Disease Committees) - CTEP- 2008594 v
									2.31</option>

								<option value="AEC89CC0-2948-4DF1-E034-080020C9C0E0">
									Trial_Type_Usage_Disease - CTEP- 2008602 v 2.31</option>

								<option value="26CFFB37-9BE0-1928-E044-0003BA3F9857">
									Tuberculosis Project - TEST- 2586709 v 1.0</option>

								<option value="99BA9DC8-84A5-4E69-E034-080020C9C0E0">
									Type of Category - CTEP- 2008591 v 3.0</option>

								<option value="CFE6B326-B645-4763-E034-0003BA12F5E7">
									TYPE OF CATEGORY - DCP- 2179692 v 1.0</option>

								<option value="99BA9DC8-84A3-4E69-E034-080020C9C0E0">
									Type of Category - CTEP- 2008589 v 2.0</option>

								<option value="00AC84E6-9D3C-6E9F-E044-0003BA3F9857">
									Type of Category - NIDCR- 2857180 v 1.0</option>

								<option value="B2E560BC-11A5-70C6-E040-BB89AD430DC2">
									Type of Category - ACRIN- 3314482 v 1.0</option>

								<option value="99BA9DC8-84A0-4E69-E034-080020C9C0E0">
									Type of Category - CIP- 2008586 v 2.0</option>

								<option value="EB5D88AB-6077-69CB-E034-0003BA3F9857">
									Type of Condition - DCP- 2194255 v 1.0</option>

								<option value="99BA9DC8-84A1-4E69-E034-080020C9C0E0">
									Type of Disease - CTEP- 2008587 v 2.0</option>

								<option value="99BA9DC8-84A2-4E69-E034-080020C9C0E0">
									TYPE OF USAGE - CTEP- 2008588 v 2.0</option>

								<option value="8292DCBE-9E1E-AE53-E040-BB89AD436FEA">
									UAMS Clinical Research - caBIG- 3029677 v 1.0</option>

								<option value="F39D919E-FD77-6610-E034-0003BA3F9857">
									UML-based Training Materials - Training- 2211656 v 1.0</option>

								<option value="B2E4B8E8-E9E6-8817-E040-BB89AD435009">
									Under Review - ACRIN- 3314514 v 1.0</option>

								<option value="A923A059-9B7C-8A7C-E040-BB89AD436548">
									University of Michigan - caBIG- 3259219 v 1.0</option>

								<option value="0F35B085-6877-1B19-E044-0003BA3F9857">
									US-VISIT - TEST- 2462747 v 1.0</option>

								<option value="62826FE8-62A5-2048-E040-BB89AD43261F">
									Utah - caBIG- 2837876 v 1.0</option>

								<option value="6A5B7F03-9887-8F51-E040-BB89AD431FF6">
									VASARI - caBIG- 2880281 v 1.0</option>

								<option value="529F65E9-8E0F-23CB-E044-0003BA3F9857">
									WCI1116-05 - caBIG- 2767602 v 1.0</option>

								<option value="246DE2D7-EAA4-46F1-E044-0003BA3F9857">
									Winter UMl Class Examples - Training- 2552643 v 1.0</option>

								<option value="07E5EACF-6F61-15DC-E044-0003BA3F9857">x
									- TEST- 2437567 v 1.0</option>

								<option value="2C39EDFD-2433-0216-E044-0003BA3F9857">
									XIP - caBIG- 2614825 v 1.0</option>

						</select>
						</td>
						<td colspan=2 valign=top><select name="selCSI" size="5"
							style="width:100%" onChange="selectCSI();"
							onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">

						</select>
						</td>
					</tr>

					<tr>
						<td height="10" valign="top">
					</tr>

					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;Selected Classification Schemes</td>
						<td><input type="button" name="btnRemoveCS"
							value="Remove Item" onClick="removeCSList();">
						</td>
						<td>&nbsp;&nbsp;Associated Classification Scheme Items</td>
						<td><input type="button" name="btnRemoveCSI"
							value="Remove Item" onClick="removeCSIList();">
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan=2 valign=top><select name="selectedCS" size="5"
							style="width:97%" multiple
							onchange="addSelectCSI(false, true, '');"
							onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">


						</select>
						</td>
						<td colspan=2 valign=top><select name="selectedCSI" size="5"
							style="width:100%" multiple onchange="addSelectedAC();"
							onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">

						</select>
						</td>
					</tr>

				</table>
			</td>
			<td>&nbsp;</td>
		</tr>
		<!-- contact info -->

		<tr>
			<td height="12" valign="top">
		</tr>
		<tr>
			<td valign="top" align=right>23 )</td>
			<td valign="bottom"><font color="#FF0000"> Select </font>

				Contacts <br>
				<table width=50% border="0">
					<col width="40%">
					<col width="15%">
					<col width="15%">
					<col width="15%">

					<tr>
						<td>&nbsp;</td>
						<td align="left"><input type="button" name="btnViewCt"
							value="Edit Item" onClick="javascript:editContact('view');"
							disabled>
						</td>
						<td align="left"><input type="button" name="btnCreateCt"
							value="Create New" onClick="javascript:editContact('new');">
						</td>
						<td align="center"><input type="button" name="btnRmvCt"
							value="Remove Item" onClick="javascript:editContact('remove');"
							disabled>
						</td>
					</tr>

					<tr>
						<td colspan=4 valign="top"><select name="selContact" size="4"
							style="width:100%" onchange="javascript:enableContButtons();"
							onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContact',helpUrl); return false">
						</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<!-- source -->
		<tr height="25" valign="bottom">
			<td align=right>24 )</td>
			<td><font color="#FF0000"> Select </font> Value Domain Origin</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><select name="selSource" size="1"
				onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selSource',helpUrl); return false">
					<option value=""></option>

					<option
						value="10 PROMIS Global Based:Based on 10 PROMIS Global Health Questionnaire">
						10 PROMIS Global Based:Based on 10 PROMIS Global Health
						Questionnaire</option>

					<option
						value="10 PROMIS® Global Health:Patient Reported Outcomes Measurement Information System Ten Question Global Health Questionnaire">
						10 PROMIS® Global Health:Patient Reported Outcomes Measurement
						Information System Ten Question Global Health Questionnaire</option>

					<option
						value="2005 NHIS QADULT:2005 National Health Interview Survey Questionnaire Sample Adult">
						2005 NHIS QADULT:2005 National Health Interview Survey
						Questionnaire Sample Adult</option>

					<option value="ABTC: Adult Brain Tumor Consortium">ABTC:
						Adult Brain Tumor Consortium</option>

					<option
						value="ACOSOG CRF:American College of Surgeons Oncology Group Case Report Form">
						ACOSOG CRF:American College of Surgeons Oncology Group Case Report
						Form</option>

					<option
						value="ACR BI-RADS(R):American College of Radiology Breast Imaging Reporting and Data System">
						ACR BI-RADS(R):American College of Radiology Breast Imaging
						Reporting and Data System</option>

					<option value="ACRIN:American College of Radiology Imaging Network">
						ACRIN:American College of Radiology Imaging Network</option>

					<option value="ACS:American Community Survey 2008 Questionnaire">
						ACS:American Community Survey 2008 Questionnaire</option>

					<option
						value="ACTG TIS Classification:AIDS Clinical Trials Group staging classification for AIDS-associated Kaposi's sarcoma">
						ACTG TIS Classification:AIDS Clinical Trials Group staging
						classification for AIDS-associated Kaposi's sarcoma</option>

					<option
						value="ADEERS:NCI/CTEP Adverse Event Expedited Report System">
						ADEERS:NCI/CTEP Adverse Event Expedited Report System</option>

					<option
						value="AJCC Based:Staging Criteria Based on American Joint Committee on Cancer System">
						AJCC Based:Staging Criteria Based on American Joint Committee on
						Cancer System</option>

					<option
						value="AJCC:American Joint Committee on Cancer Cancer Staging Manual, 6th Ed., 2002">
						AJCC:American Joint Committee on Cancer Cancer Staging Manual, 6th
						Ed., 2002</option>

					<option
						value="AJCC:American Joint Committee on Cancer Cancer Staging Manual, 7th Ed., 2009">
						AJCC:American Joint Committee on Cancer Cancer Staging Manual, 7th
						Ed., 2009</option>

					<option
						value="ALSPAC:Avon Longitudinal Study of Parents and Children Protocol">
						ALSPAC:Avon Longitudinal Study of Parents and Children Protocol</option>

					<option value="AMC CRF:AIDS Malignancy Consortium Case Report Form">
						AMC CRF:AIDS Malignancy Consortium Case Report Form</option>

					<option value="Anthropometric Standardization Reference Manual">
						Anthropometric Standardization Reference Manual</option>

					<option value="ARIC Protocol 11; 4/16/1987">ARIC Protocol
						11; 4/16/1987</option>

					<option
						value="ASA24:Automated Self-Administered 24-hour Dietary Recall, NCI">
						ASA24:Automated Self-Administered 24-hour Dietary Recall, NCI</option>

					<option value="ASC Based: Based on Assessment of Survivor Concerns">
						ASC Based: Based on Assessment of Survivor Concerns</option>

					<option
						value="ASC:Assessment of Survivor Concerns Gotay CC & Pagano IS. Health Qual Life Outcomes. 2007 Mar 13;5:15">
						ASC:Assessment of Survivor Concerns Gotay CC & Pagano IS. Health
						Qual Life Outcomes. 2007 Mar 13;5:15</option>

					<option value="ASCO:American Society of Clinical Oncology">
						ASCO:American Society of Clinical Oncology</option>

					<option value="AUA:American Urological Association">
						AUA:American Urological Association</option>

					<option
						value="BCTOS Based:Based on Breast Cancer Treatment Outcomes Scale">
						BCTOS Based:Based on Breast Cancer Treatment Outcomes Scale</option>

					<option
						value="BCTOS:Breast Cancer Treatment Outcomes Scale Questionnaire. Stanton AL, Krishnan L, Collins CA: Cancer 91:2273-81, 2001.">
						BCTOS:Breast Cancer Treatment Outcomes Scale Questionnaire.
						Stanton AL, Krishnan L, Collins CA: Cancer 91:2273-81, 2001.</option>

					<option value="BIS Based:Based on Body Image Scale">BIS
						Based:Based on Body Image Scale</option>

					<option
						value="BIS:Body Image Scale Hopwood P, Fletcher I, Lee A, et al: A body image scale for use with cancer patients. European Journal of Cancer 37:189-197, 2001.">
						BIS:Body Image Scale Hopwood P, Fletcher I, Lee A, et al: A body
						image scale for use with cancer patients. European Journal of
						Cancer 37:189-197, 2001.</option>

					<option value="Bladder CDE Disease Committee">Bladder CDE
						Disease Committee</option>

					<option value="Brain CDE Disease Committee">Brain CDE
						Disease Committee</option>

					<option value="Breast CDE Disease Committee">Breast CDE
						Disease Committee</option>

					<option value="caBIG:Cancer Biomedical Informatics Grid">
						caBIG:Cancer Biomedical Informatics Grid</option>

					<option
						value="CALGB CRF:Cancer and Leukemia Group B Case Report Form">
						CALGB CRF:Cancer and Leukemia Group B Case Report Form</option>

					<option value="Cancer Family Registry Data Committee">
						Cancer Family Registry Data Committee</option>

					<option
						value="CAP PROTOCOLS:College of American Pathologists Cancer Protocols">
						CAP PROTOCOLS:College of American Pathologists Cancer Protocols</option>

					<option value="CAP:College of American Pathologists">
						CAP:College of American Pathologists</option>

					<option
						value="CARDIA:Coronary Artery Risk Development in Young Adults Study">
						CARDIA:Coronary Artery Risk Development in Young Adults Study</option>

					<option value="CCR:Center for Cancer Research">CCR:Center
						for Cancer Research</option>

					<option value="CDC:Center for Disease Control">CDC:Center
						for Disease Control</option>

					<option
						value="CDISC:Clinical Data Interchange Standards Consortium">
						CDISC:Clinical Data Interchange Standards Consortium</option>

					<option value="CDS:Clinical Data System">CDS:Clinical Data
						System</option>

					<option value="CDUS:Clinical Data Update System">
						CDUS:Clinical Data Update System</option>

					<option value="CFR:Code of Federal Regulations">CFR:Code
						of Federal Regulations</option>

					<option
						value="CHIS:California Health Interview Survey 2005 Adult Questionnaire">
						CHIS:California Health Interview Survey 2005 Adult Questionnaire</option>

					<option value="CHS:Cardiovascular Health Study">
						CHS:Cardiovascular Health Study</option>

					<option value="CHTN:Cooperative Human Tissue Network">
						CHTN:Cooperative Human Tissue Network</option>

					<option
						value="CIA:The World Factbook Cross-Reference List of Country Data Codes">
						CIA:The World Factbook Cross-Reference List of Country Data Codes
					</option>

					<option value="COC:Commission on Cancer">COC:Commission on
						Cancer</option>

					<option value="COG CRF:Children's Oncology Group Case Report Form">
						COG CRF:Children's Oncology Group Case Report Form</option>

					<option value="Colorectal CDE Disease Committee">
						Colorectal CDE Disease Committee</option>

					<option
						value="Confirmation of Molecular Signatures of Early Lung Adenocarcinoma">
						Confirmation of Molecular Signatures of Early Lung Adenocarcinoma
					</option>

					<option value="Cooperative Group-Forms Committee">
						Cooperative Group-Forms Committee</option>

					<option
						value="CROWN CRF:Community Research for Oral Wellness Network Case Report Form">
						CROWN CRF:Community Research for Oral Wellness Network Case Report
						Form</option>

					<option
						value="CTCAE:Common Terminology Criteria for Adverse Events v3.0">
						CTCAE:Common Terminology Criteria for Adverse Events v3.0</option>

					<option
						value="CTCAEv4.0:Common Terminology Criteria for Adverse Events v4.0">
						CTCAEv4.0:Common Terminology Criteria for Adverse Events v4.0</option>

					<option value="CTEP CDE Committee">CTEP CDE Committee</option>

					<option value="CTEP:Cancer Therapy Evaluation Program">
						CTEP:Cancer Therapy Evaluation Program</option>

					<option value="CTEP:Phase II Breast CDE Disease Committee">
						CTEP:Phase II Breast CDE Disease Committee</option>

					<option
						value="CTMS:caBIG Clinical Trials Management Systems Workspace">
						CTMS:caBIG Clinical Trials Management Systems Workspace</option>

					<option value="CTMS:Clinical Trials Monitoring Service">
						CTMS:Clinical Trials Monitoring Service</option>

					<option value="DCP:Division of Cancer Prevention">
						DCP:Division of Cancer Prevention</option>

					<option
						value="DEQAS:Vitamin D Extenral Quality Assessment Scheme htp://www.deqas.org/">
						DEQAS:Vitamin D Extenral Quality Assessment Scheme
						htp://www.deqas.org/</option>

					<option
						value="DICOM:Digital Imaging and Communications in Medicine">
						DICOM:Digital Imaging and Communications in Medicine</option>

					<option value="Director's Challenge Lung Study">
						Director's Challenge Lung Study</option>

					<option
						value="DPBRN CRF:Dental Practice-Based Research Network Case Report Form">
						DPBRN CRF:Dental Practice-Based Research Network Case Report Form
					</option>

					<option
						value="ECOG CRF:Eastern Cooperative Oncology Group Case Report Form">
						ECOG CRF:Eastern Cooperative Oncology Group Case Report Form</option>

					<option value="EDRN:Early Detection Research Network">
						EDRN:Early Detection Research Network</option>

					<option value="ELCAP:Early Lung Cancer Action Program">
						ELCAP:Early Lung Cancer Action Program</option>

					<option
						value="eMERGE:Electronic Medical Records and Genomics Network">
						eMERGE:Electronic Medical Records and Genomics Network</option>

					<option
						value="EORTC QLQ-Pan26: EORTC Quality of Life Questionnaire Pancreas 26">
						EORTC QLQ-Pan26: EORTC Quality of Life Questionnaire Pancreas 26</option>

					<option value="EPIC:Expanded Prostate Cancer Index Composite">
						EPIC:Expanded Prostate Cancer Index Composite</option>

					<option
						value="EPP CRF:Expanded Participation Project Case Report Form">
						EPP CRF:Expanded Participation Project Case Report Form</option>

					<option value="ePRO:ePRO Data Dictionary">ePRO:ePRO Data
						Dictionary</option>

					<option value="EQ-5D-5L:EuroQol Group EQ-5D Health Questionnaire">
						EQ-5D-5L:EuroQol Group EQ-5D Health Questionnaire</option>

					<option value="FAB Classification">FAB Classification</option>

					<option value="FACIT: FACIT Fatigue Scale Version 4">
						FACIT: FACIT Fatigue Scale Version 4</option>

					<option
						value="FACT-G Based:Based on Functional Assessment of Cancer Therapy - General">
						FACT-G Based:Based on Functional Assessment of Cancer Therapy -
						General</option>

					<option
						value="FACT-G:Functional Assessment of Cancer Therapy - General">
						FACT-G:Functional Assessment of Cancer Therapy - General</option>

					<option
						value="FACT:Functional Assessment of Cancer Therapy Quality of Life Scale">
						FACT:Functional Assessment of Cancer Therapy Quality of Life Scale</option>

					<option value="Fagerstrom Test">Fagerstrom Test</option>

					<option
						value="FAHI:Functional Assessment of Human Immunodeficiency Virus Infection">
						FAHI:Functional Assessment of Human Immunodeficiency Virus
						Infection</option>

					<option value="FDA:Food and Drug Administration">FDA:Food
						and Drug Administration</option>

					<option
						value="FIGO:International Federal of Gynecology and Obstetrics">
						FIGO:International Federal of Gynecology and Obstetrics</option>

					<option
						value="FIGO:International Federation of Gynecology and Obstretrics Endometrial Staging 2009">
						FIGO:International Federation of Gynecology and Obstretrics
						Endometrial Staging 2009</option>

					<option
						value="FIREBIRD:Federal Investigator Registry of Biomedical Informatics Research Data">
						FIREBIRD:Federal Investigator Registry of Biomedical Informatics
						Research Data</option>

					<option value="Framingham Heart Study">Framingham Heart
						Study</option>

					<option
						value="Fred Hutchinson Cancer Research Center, Caffeine Questionnaire, 2004">
						Fred Hutchinson Cancer Research Center, Caffeine Questionnaire,
						2004</option>

					<option value="French System of Histology">French System
						of Histology</option>

					<option value="G-A100">G-A100</option>

					<option value="GBC:Group Banking Committee">GBC:Group
						Banking Committee</option>

					<option
						value="Gilly Classification: Gilly Classification published by Gilly et al., 1994, for the characterization of Peritoneal Carcinomatosis">
						Gilly Classification: Gilly Classification published by Gilly et
						al., 1994, for the characterization of Peritoneal Carcinomatosis</option>

					<option
						value="Global Network for Women's and Children's Health Research">
						Global Network for Women's and Children's Health Research</option>

					<option value="GO:Gene Ontology">GO:Gene Ontology</option>

					<option value="GOG CRF:Gynecologic Oncology Group Case Report Form">
						GOG CRF:Gynecologic Oncology Group Case Report Form</option>

					<option value="Grooved Pegboard Test, Lezak, 1995">
						Grooved Pegboard Test, Lezak, 1995</option>

					<option value="Gynecologic CDE Disease Committee">
						Gynecologic CDE Disease Committee</option>

					<option value="HAQ-II:Health Assessment Questionnaire-II">
						HAQ-II:Health Assessment Questionnaire-II</option>

					<option value="HEI:Health Eating Index-2005">HEI:Health
						Eating Index-2005</option>

					<option value="HES:Health Examination Survey">HES:Health
						Examination Survey</option>

					<option value="HITSP:Healthcare Information Technology Panel">
						HITSP:Healthcare Information Technology Panel</option>

					<option value="HL7:Health Level Seven">HL7:Health Level
						Seven</option>

					<option value="HOW:Health of Women (HOW) Study 11.16.2009">
						HOW:Health of Women (HOW) Study 11.16.2009</option>

					<option
						value="HVLT-R:Hopkins Verbal Learning Test-Revised, Jason Brandt, PhD, 1991">
						HVLT-R:Hopkins Verbal Learning Test-Revised, Jason Brandt, PhD,
						1991</option>

					<option
						value="IBCSG CRF:International Breast Cancer Study Group Case Report Form">
						IBCSG CRF:International Breast Cancer Study Group Case Report Form</option>

					<option value="IBMTR:International Bone Marrow Transplant Registry">
						IBMTR:International Bone Marrow Transplant Registry</option>

					<option value="ICD:International Classification of Diseases">
						ICD:International Classification of Diseases</option>

					<option value="ICH:International Conference on Harmonization">
						ICH:International Conference on Harmonization</option>

					<option value="ICR:caBIG Integrative Cancer Research Workspace">
						ICR:caBIG Integrative Cancer Research Workspace</option>

					<option value="IMT:International Medical Terminology">
						IMT:International Medical Terminology</option>

					<option value="INFORMED CONSENT">INFORMED CONSENT</option>

					<option
						value="ISA-TAB-Nano:Investigation Study Assay Excel Table Format for Nanotechnology">
						ISA-TAB-Nano:Investigation Study Assay Excel Table Format for
						Nanotechnology</option>

					<option value="ISCN Karyotype Description">ISCN Karyotype
						Description</option>

					<option value="ISO:International Organization for Standardization">
						ISO:International Organization for Standardization</option>

					<option value="IVI:caBIG In Vivo Imaging Workspace">
						IVI:caBIG In Vivo Imaging Workspace</option>

					<option
						value="LCBCC:Lung Cancer Biomarkers and Chemoprevention Consortium">
						LCBCC:Lung Cancer Biomarkers and Chemoprevention Consortium</option>

					<option value="Leukemia CDE Disease Committee">Leukemia
						CDE Disease Committee</option>

					<option value="LIDC:Lung Imaging Database Consortium">
						LIDC:Lung Imaging Database Consortium</option>

					<option
						value="LOINC:Logical Observation Identifiers Numbers and Codes">
						LOINC:Logical Observation Identifiers Numbers and Codes</option>

					<option value="Lung CDE Disease Committee">Lung CDE
						Disease Committee</option>

					<option value="Lymphoma CDE Disease Committee">Lymphoma
						CDE Disease Committee</option>

					<option value="M-09030">M-09030</option>

					<option
						value="MBSRQ-Appearance Based:Based on Multidimensional Body Self-Relations Questionnaire-Appearance Scale">
						MBSRQ-Appearance Based:Based on Multidimensional Body
						Self-Relations Questionnaire-Appearance Scale</option>

					<option
						value="MBSRQ-Appearance Orientation:Multidimensional Body Self-Relations Questionnaire-Appearance Scale, Brown, TA., Cash, TF, Mikulka, PJ. J Pers Assess. 1990; 55: 135-44.">
						MBSRQ-Appearance Orientation:Multidimensional Body Self-Relations
						Questionnaire-Appearance Scale, Brown, TA., Cash, TF, Mikulka, PJ.
						J Pers Assess. 1990; 55: 135-44.</option>

					<option
						value="MDASI-HN:M.D. Anderson Symptom Inventory - Head & Neck, copyright 2000">
						MDASI-HN:M.D. Anderson Symptom Inventory - Head & Neck, copyright
						2000</option>

					<option
						value="Measure Instrument:Based on NCI requirement to capture text response for question item.">
						Measure Instrument:Based on NCI requirement to capture text
						response for question item.</option>

					<option value="MedDRA v12.0">MedDRA v12.0</option>

					<option value="MedDRA:Medical Dictionary for Regulatory Affairs">
						MedDRA:Medical Dictionary for Regulatory Affairs</option>

					<option value="Melanoma CDE Disease Committee">Melanoma
						CDE Disease Committee</option>

					<option
						value="MGED Ontology:Microarray Gene Expression Data Ontology">
						MGED Ontology:Microarray Gene Expression Data Ontology</option>

					<option value="MGED:Microarray Gene Expression Data">
						MGED:Microarray Gene Expression Data</option>

					<option value="MMQL: Minneapolis-Manchester QOL Survey of Health">
						MMQL: Minneapolis-Manchester QOL Survey of Health</option>

					<option
						value="MPQ:McGill Pain Questionnaire Short Form, Melzack R, 1987.">
						MPQ:McGill Pain Questionnaire Short Form, Melzack R, 1987.</option>

					<option value="Murphy Stage">Murphy Stage</option>

					<option value="Myeloma CDE Disease Committee">Myeloma CDE
						Disease Committee</option>

					<option
						value="NAACCR:North American Association of Central Cancer Registries">
						NAACCR:North American Association of Central Cancer Registries</option>

					<option value="NCCCP:NCI Community Cancer Centers Program">
						NCCCP:NCI Community Cancer Centers Program</option>

					<option
						value="NCCTG CRF:North Central Cancer Treatment Group Case Report Form">
						NCCTG CRF:North Central Cancer Treatment Group Case Report Form</option>

					<option value="NCI Net-Trials">NCI Net-Trials</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option
						value="NCIC CRF:National Cancer Institute of Canada Case Report Form">
						NCIC CRF:National Cancer Institute of Canada Case Report Form</option>

					<option value="NDC:National Drug Code">NDC:National Drug
						Code</option>

					<option
						value="NDSR:Nutrition Data System for Research, University of Minnesota">
						NDSR:Nutrition Data System for Research, University of Minnesota</option>

					<option
						value="NHANES:National Health and Nutrition Examination Survey 2003-2004">
						NHANES:National Health and Nutrition Examination Survey 2003-2004
					</option>

					<option
						value="NHANES:National Health and Nutrition Examination Survey 2005-2006">
						NHANES:National Health and Nutrition Examination Survey 2005-2006
					</option>

					<option
						value="NHANES:National Health and Nutrition Examination Survey 2005-2006, Health Insurance Section">
						NHANES:National Health and Nutrition Examination Survey 2005-2006,
						Health Insurance Section</option>

					<option
						value="NHANES:National Health and Nutrition Examination Survey 2005-2006, Screener Module 1">
						NHANES:National Health and Nutrition Examination Survey 2005-2006,
						Screener Module 1</option>

					<option
						value="NHANES:National Health and Nutrition Examination Survey 2007-2008">
						NHANES:National Health and Nutrition Examination Survey 2007-2008
					</option>

					<option
						value="NHANES:National Health and Nutrition Examination Survey 3, 1988-1994">
						NHANES:National Health and Nutrition Examination Survey 3,
						1988-1994</option>

					<option value="NHANES:National Health Examination Survey, CDC">
						NHANES:National Health Examination Survey, CDC</option>

					<option
						value="NHIS:National Health Interview Survey Family Questionnaire, 2007">
						NHIS:National Health Interview Survey Family Questionnaire, 2007</option>

					<option value="NHIS:National Health Interview Survey, 2005">
						NHIS:National Health Interview Survey, 2005</option>

					<option value="NHLBI FBPP:Family Blood Pressure Program">
						NHLBI FBPP:Family Blood Pressure Program</option>

					<option
						value="NINDS:National Institute of Neurological Disorders and Stroke Common Data Element Project">
						NINDS:National Institute of Neurological Disorders and Stroke
						Common Data Element Project</option>

					<option value="NMDP:National Marrow Donor Program">
						NMDP:National Marrow Donor Program</option>

					<option value="NOVARTIS:Novartis">NOVARTIS:Novartis</option>

					<option
						value="NSABP CRF:National Surgical Adjuvant Breast and Bowel Project Case Report Form">
						NSABP CRF:National Surgical Adjuvant Breast and Bowel Project Case
						Report Form</option>

					<option value="NVSS:National Vital Statistics System - CDC">
						NVSS:National Vital Statistics System - CDC</option>

					<option value="OHIP:Oral Health Impact Profile">OHIP:Oral
						Health Impact Profile</option>

					<option
						value="OMB/NCI:Office of Management and Budget/National Cancer Institute">
						OMB/NCI:Office of Management and Budget/National Cancer Institute
					</option>

					<option value="OMRS:Oral Mucositis Rating Scale">
						OMRS:Oral Mucositis Rating Scale</option>

					<option value="Pathology CDE Disease Committee">Pathology
						CDE Disease Committee</option>

					<option value="PCF:Prostate Cancer Foundation">
						PCF:Prostate Cancer Foundation</option>

					<option value="PCM:Patient Care Monitor">PCM:Patient Care
						Monitor</option>

					<option
						value="PEARL CRF:Practitioners Engaged in Applied Research and Learning Network Case Report Form">
						PEARL CRF:Practitioners Engaged in Applied Research and Learning
						Network Case Report Form</option>

					<option
						value="PedsQL: Pediatric Quality of Life, James W. Varni, Ph.D., 1998">
						PedsQL: Pediatric Quality of Life, James W. Varni, Ph.D., 1998</option>

					<option value="Phase II Lung CDE Disease Committee">Phase
						II Lung CDE Disease Committee</option>

					<option value="POM:Pain-O-Meter">POM:Pain-O-Meter</option>

					<option
						value="PRAMS:Pregnancy Risk Assessment Monitoring System, 2004-2008">
						PRAMS:Pregnancy Risk Assessment Monitoring System, 2004-2008</option>

					<option
						value="PRECEDENT CRF:Practice-based Research Collaborative in Evidence-Based Dentistry Case Report Form">
						PRECEDENT CRF:Practice-based Research Collaborative in
						Evidence-Based Dentistry Case Report Form</option>

					<option value="Prostate CDE Disease Committee">Prostate
						CDE Disease Committee</option>

					<option value="PSID:Panel Study of Income Dynamics, 2007">
						PSID:Panel Study of Income Dynamics, 2007</option>

					<option value="PSS:Perceived Stress Scale">PSS:Perceived
						Stress Scale</option>

					<option
						value="QLAC:Quality of Life in Adult Cancer Survivors Scale">
						QLAC:Quality of Life in Adult Cancer Survivors Scale</option>

					<option value="Radiology Committee">Radiology Committee</option>

					<option value="Radiology Committee, UMLS- C0439200">
						Radiology Committee, UMLS- C0439200</option>

					<option value="RAI Staging">RAI Staging</option>

					<option value="REAL Classification">REAL Classification</option>

					<option value="RECIST:Response Evaluation Criteria in Solid Tumors">
						RECIST:Response Evaluation Criteria in Solid Tumors</option>

					<option
						value="Reference guideline for Solid Tumor Disease: J National Cancer Institute 92(3):205-216, 2000.">
						Reference guideline for Solid Tumor Disease: J National Cancer
						Institute 92(3):205-216, 2000.</option>

					<option
						value="RTOG CRF:Radiation Therapy Oncology Group Case Report Form">
						RTOG CRF:Radiation Therapy Oncology Group Case Report Form</option>

					<option value="Sarcoma CDE Disease Committee">Sarcoma CDE
						Disease Committee</option>

					<option value="SDPS:San Diego Population Study">SDPS:San
						Diego Population Study</option>

					<option value="SEER:Surveillance Epidemiology and End Results, NCI">
						SEER:Surveillance Epidemiology and End Results, NCI</option>

					<option value="SHIM:Sexual Health Inventory for Men (SHIM)">
						SHIM:Sexual Health Inventory for Men (SHIM)</option>

					<option value="SIC">SIC</option>

					<option value="Sipes et al, NEUROLOGY 34;1984">Sipes et
						al, NEUROLOGY 34;1984</option>

					<option value="Skindex-29 Copyright 1996, M.-M. Chren, MD">
						Skindex-29 Copyright 1996, M.-M. Chren, MD</option>

					<option value="SNOMED:Systematized Nomenclature of Medicine">
						SNOMED:Systematized Nomenclature of Medicine</option>

					<option value="SNS:Subjective Numeracy Scale">
						SNS:Subjective Numeracy Scale</option>

					<option value="SPOREs:Scientific Programs of Research Excellence">
						SPOREs:Scientific Programs of Research Excellence</option>

					<option
						value="Stunkard, A; et al. Use of the Danish Adoption Registry for the study of obesity and thinness, 1983, 115-120.">
						Stunkard, A; et al. Use of the Danish Adoption Registry for the
						study of obesity and thinness, 1983, 115-120.</option>

					<option value="SURE-QX:Supplement Reporting Questionnaire">
						SURE-QX:Supplement Reporting Questionnaire</option>

					<option value="SWOG CRF:Southwest Oncology Group Case Report Form">
						SWOG CRF:Southwest Oncology Group Case Report Form</option>

					<option
						value="Tanner Scale/Stage:Tanner JM. Growth at adolescence. 2d ed. Oxford: Blackwell, 1962.">
						Tanner Scale/Stage:Tanner JM. Growth at adolescence. 2d ed.
						Oxford: Blackwell, 1962.</option>

					<option
						value="TBPT:caBIG Tissue Banks and Pathology Tools Workspace">
						TBPT:caBIG Tissue Banks and Pathology Tools Workspace</option>

					<option value="TCGA:The Cancer Genome Atlas">TCGA:The
						Cancer Genome Atlas</option>

					<option value="THERADEX:Theradex Systems Inc">
						THERADEX:Theradex Systems Inc</option>

					<option
						value="Trail Making Test by US Army, 1944 as part of the  Army Individual Test of General Ability">
						Trail Making Test by US Army, 1944 as part of the Army Individual
						Test of General Ability</option>

					<option value="Transplant CDE Committee">Transplant CDE
						Committee</option>

					<option value="UMLS:Unified Medical Language System, NLM">
						UMLS:Unified Medical Language System, NLM</option>

					<option value="Upper Gastrointestinal CDE Disease Committee">
						Upper Gastrointestinal CDE Disease Committee</option>

					<option value="UWD_VA:University of Washington Visual Anatomist">
						UWD_VA:University of Washington Visual Anatomist</option>

					<option
						value="VA NDFRT:Veterans Administration National Drug File Reference Terminology">
						VA NDFRT:Veterans Administration National Drug File Reference
						Terminology</option>

					<option value="VASARI:Visually AccesSAble Rembrandt Images">
						VASARI:Visually AccesSAble Rembrandt Images</option>

					<option
						value="VCDE:caBIG Vocabulary and Common Data Elements Workspace">
						VCDE:caBIG Vocabulary and Common Data Elements Workspace</option>

					<option value="VRS:Vienna Rectoscopy Score">VRS:Vienna
						Rectoscopy Score</option>

					<option value="WHI:Women's Health Initiative">WHI:Women's
						Health Initiative</option>

					<option value="WHO:World Health Organization">WHO:World
						Health Organization</option>

					<option value="WHODD:World Health Organization Drug Dictionary">
						WHODD:World Health Organization Drug Dictionary</option>

					<option value="Zebrafish">Zebrafish</option>

					<option value="" selected></option>

			</select>
			</td>
		</tr>
		<tr height="25" valign="bottom">
			<td align=right>25 )</td>
			<td><font color="#FF0000"> Create </font> Change Note</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><textarea name="CreateChangeNote" cols="70%"
					onHelp="showHelp('html/Help_CreateVD.html#createVDForm_CreateComment',helpUrl); return false"
					rows=2></textarea>
			</td>
		</tr>

		<tr height="25" valign="bottom">
			<td align=right>26 )</td>
			<td><font color="#FF0000"> <a
					href="javascript:SubmitValidate('validate')"> Validate </a> </font> the
				Value Domain(s)</td>
		</tr>

	</table>
	<div style="display:none">
		<input type="hidden" name="vdIDSEQ"
			value="E3BF78C8-8EF1-6255-E034-0003BA12F5E7"> <input
			type="hidden" name="CDE_IDTxt" value="2188327"> <input
			type="hidden" name="actSelect" value=""> <input type="hidden"
			name="pageAction" value="nothing">
		<!--<input type="hidden" name="hiddenPValue" value="">
<input type="hidden" name="VMOrigin" value="ValueDomain">-->
		<input type="hidden" name="selObjectClassText" value=""> <input
			type="hidden" name="selPropertyClassText" value=""> <input
			type="hidden" name="selObjectQualifierText" value=""> <input
			type="hidden" name="selPropertyQualifierText" value=""> <input
			type="hidden" name="selRepTermText" value="Name"> <input
			type="hidden" name="selObjectClassLN" value=""> <input
			type="hidden" name="selPropertyClassLN" value=""> <input
			type="hidden" name="selObjectQualifierLN" value=""> <input
			type="hidden" name="selPropertyQualifierLN" value=""> <input
			type="hidden" name="selRepTermLN" value="Name"> <input
			type="hidden" name="selRepTermID"
			value="F6EF4E2B-76AE-72C1-E034-0003BA3F9857"> <input
			type="hidden" name="selRepQualifierLN" value=""> <input
			type="hidden" name="selRepQualifierText" value=""> <input
			type="hidden" name="selConceptualDomainText"
			value="Anatomic Sites - CTEP"> <input type="hidden"
			name="selContextText" value="NCIP"> <input type="hidden"
			name="VDAction" value="EditVD"> <input type="hidden"
			name="MenuAction" value="editVD"> <input type="hidden"
			name="valueCount" value="0"> <input type="hidden"
			name="selObjRow" value=""> <input type="hidden"
			name="selPropRow" value=""> <input type="hidden"
			name="selRepRow" value=""> <input type="hidden"
			name="selObjQRow" value=""> <input type="hidden"
			name="selPropQRow" value=""> <input type="hidden"
			name="selRepQRow" value=""> <input type="hidden"
			name="PropDefinition" value=""> <input type="hidden"
			name="ObjDefinition" value=""> <input type="hidden"
			name="RepDefinition" value=""> <input type="hidden"
			name="openToTree" value=""> <input type="hidden"
			name="RepQualID" value=""> <input type="hidden"
			name="RepQualVocab" value=""> <input type="hidden"
			name="RepTerm_ID" value="C42614"> <input type="hidden"
			name="RepTermVocab" value="NCI Thesaurus"> <input
			type="hidden" name="sCompBlocks" id="sCompBlocks" value=""> <input
			type="hidden" name="nvpConcept" id="nvpConcept" value=""> <input
			type="hidden" name="RepQualCCode" value=""> <input
			type="hidden" name="RepQualCCodeDB" value=""> <input
			type="hidden" name="RepCCode" value="C42614"> <input
			type="hidden" name="RepCCodeDB" value="NCI Thesaurus"> <input
			type="hidden" name="nameTypeChange" value="false"> <select
			name="selCSCSIHidden" size="1" style="visibility:hidden;" multiple></select>
		<select name="selACCSIHidden" size="1" style="visibility:hidden;"
			multiple></select> <select name="selCSNAMEHidden" size="1"
			style="visibility:hidden;" multiple></select>
		<!-- store the selected ACs in the hidden field to use it for cscsi -->
		<select name="selACHidden" size="1"
			style="visibility:hidden;width:100;" multiple>

			<option value="E3BF78C8-8EF1-6255-E034-0003BA12F5E7">
				Anatomic Site Location Text Name</option>

		</select> <select name="vRepQualifierCodes" size="1"
			style="visibility:hidden;width:100;" multiple>

		</select> <select name="vRepQualifierDB" size="1"
			style="visibility:hidden;width:100;" multiple>

		</select>
		<!-- store datatype description to use later -->
		<select name="datatypeDesc" size="1"
			style="visibility:hidden;width:100;" multiple>

			<option value=""></option>

			<option value="Please use 'Date Alpha DVG' or 'Numeric Alpha DVG'">
				July 22, 2005 the Oracle Clinical "Alpha DVG" is planned to be
				discontinued. ?Alpha DVG? has been split into two datatypes, please
				use either "Date Alpha DVG" or "Numeric Alpha DVG".</option>

			<option value="A mix of numeric and alphabetic characters">

			</option>

			<option value="Local data type that represents any UML Class.">

			</option>

			<option value="A representation with only two unique components.">

			</option>

			<option value="A binary large object such as a document or image.">

			</option>

			<option
				value="The mathematical datatype associated with two-valued logic.">
				ISO 11404 Datatypes</option>

			<option value="Distinct values in no particular order."></option>

			<option
				value="A character string of letters, symbols, and/or numbers">

			</option>

			<option value="A date specifying month, day, and year"></option>

			<option
				value="Oracle Clinical datatype-contains alphanumeric and Date data">
				The Oracle "Date Alpha DVG" datatype signifies that data fields with
				the type Date can contain alphanumeric data in addition to the type
				of data defined by the original datatype. The assignment of this
				datatype permits validation of specified alphanumeric data codes and
				allows them to be entered without alerting the data entry operator
				or necessarily creating a discrepancy. For example, a field used for
				recording a Birth Date would accept the text "Unknown" in addition
				to a numeric date without causing an error. Examples at
				http://www.csscomp.com/web/training/docs/Global_Library_4_Practice.pdf
			</option>

			<option value="DATE/TIME"></option>

			<option
				value="A date (month,day,year) and time (hours,minutes,seconds).">

			</option>

			<option value="Rule controlling data element content">
				Applied for ISO 11179 derivations</option>

			<option value="A local java datatype - Property."></option>

			<option value="A local java datatype - Role."></option>

			<option value="A local java datatype - Source."></option>

			<option value="A local java datatype - TreeNode."></option>

			<option value="Parametric probability distribution."></option>

			<option value="Content model for addresses."></option>

			<option value="Parts for mailing and home or office addresses.">

			</option>

			<option value="An additional locator in the address."></option>

			<option value="An address line in the address."></option>

			<option value="A building number numeric in the address."></option>

			<option value="A building number in the address."></option>

			<option value="A bulding number suffix in the address."></option>

			<option value="A break in the address."></option>

			<option value="Care of in the address."></option>

			<option value="A census track in the address."></option>

			<option value="A country in the address."></option>

			<option value="A county or parish in the address."></option>

			<option value="A delivery address line in the address."></option>

			<option value="A delivery address line in the address."></option>

			<option value="A delivery installation area in the address.">

			</option>

			<option value="A delivery installation qualifier in the address.">

			</option>

			<option value="A direction in the address."></option>

			<option value="A delivery installation type in the address.">

			</option>

			<option value="A delivery mode in the address."></option>

			<option value="A delivery mode identifier in the address.">

			</option>

			<option value="An intersection in the address."></option>

			<option value="A post box in the address."></option>

			<option value="A precinct in the address."></option>

			<option value="A street address in the address."></option>

			<option value="A state or province in the address."></option>

			<option value="A street name base in the address."></option>

			<option value="A street name in the address."></option>

			<option value="A street type in the address."></option>

			<option value="A unit identifier in the address."></option>

			<option value="A unit designator in the address."></option>

			<option
				value="String with a type-tag to signify its role in the address.">

			</option>

			<option value="A postal code in the address."></option>

			<option value="Defines the basic property of every data value.">

			</option>

			<option
				value="Unordered set of values which can appear more than once.">

			</option>

			<option value="Constrains instance of BL not to have a nullFlavor">

			</option>

			<option value="Values of two-valued logic."></option>

			<option value="Base concept descriptor attributes."></option>

			<option
				value="Constrains CD to a single code to be sent for given value.">

			</option>

			<option
				value="Reference a concept defined by a referenced code system.">

			</option>

			<option
				value="Abstract - collects common properties/behaviors of classes.">

			</option>

			<option value="Coded values associated with a specific order.">

			</option>

			<option
				value="Coded data in simplest form, only code is not predetermined.">

			</option>

			<option
				value="A collection containing unordered distinct/discrete values.">

			</option>

			<option
				value="Constrains ED to contain only a non-referenced document.">

			</option>

			<option value="Constrains ED to contain only a referenced document.">

			</option>

			<option value="Constrains ED so that the contents must be an image.">

			</option>

			<option
				value="Constrains ED to only contain an XML digital signature.">

			</option>

			<option value="Constrains ED to only contain a structured title.">

			</option>

			<option value="Constrains ED to only contain a structured narrative.">

			</option>

			<option value="Constrains ED so that it may only contain plain text.">

			</option>

			<option
				value="Data only for human interpretation or machine processing.">

			</option>

			<option value="Event-related periodic interval of time."></option>

			<option value="Organization Name constraint on Entity Name.">

			</option>

			<option value="Person Name constraint on Entity Name."></option>

			<option value="Trivial Name constraint on Entity Name."></option>

			<option value="A name for a person, organization, place or thing.">

			</option>

			<option
				value="A character string token representing a part of a name.">

			</option>

			<option value="Generated sequence."></option>

			<option
				value="Constrains QSI(TS) to intersection of IVL(TS) and PIVL(TS)">

			</option>

			<option value="Items in historical order.     "></option>

			<option value="Provides the history of a value"></option>

			<option
				value="Identifier that uniquely identifies a thing or object.">

			</option>

			<option value="Constrains INT to a value of 0 or greater.">

			</option>

			<option value="Constrains INT to a value of greater than 0.">

			</option>

			<option value="Number results from counting and enumerating.">

			</option>

			<option
				value="Constrains IVL so high is provided and highClosed is true.">

			</option>

			<option
				value="Constrains IVL so low is provided and lowClosed is true.">

			</option>

			<option
				value="Set of consecutive values of an ordered base datatype.">

			</option>

			<option value="Constrains IVL so width is mandatory and low.">

			</option>

			<option value="Collection of discrete values in a defined sequence.">

			</option>

			<option value="Amount of money."></option>

			<option value="A set of UVP with probabilities."></option>

			<option value="An interval of time that recurs periodically.">

			</option>

			<option value="Extended coded physical quantiy value with a unit.">

			</option>

			<option
				value="Constrains PQ to have units that describe a period of time.">

			</option>

			<option
				value="Dimensioned quantity expressing the result of measuring.">

			</option>

			<option value="An abstract precursor type for PQ and PQR.">

			</option>

			<option
				value="Specifies a QSET  that describes a predefined QSET(TS).">

			</option>

			<option value="Specifies a QSET as a union of other sets.">

			</option>

			<option
				value="Unordered set of distinctive values which are quantities.">

			</option>

			<option value="Specifies a QSET as an intersection of other sets.">

			</option>

			<option
				value="Specifies a QSET as the periodic hull between two sets.">

			</option>

			<option value="Specifies a QSET as an enumeration of simple values.">

			</option>

			<option value="Specifies a QSET as a union of other sets.">

			</option>

			<option value="Abstract generalization quantity datatype.">

			</option>

			<option value="Fractional numbers represented by decimals.">

			</option>

			<option
				value="Quantity quotient of a numerator divided by a denominator.">

			</option>

			<option value="Constrains SC so that no translations are allowed.">

			</option>

			<option
				value="Character string that optionally may have a code attached.">

			</option>

			<option
				value="Sequence values scaled & translated from a list of integers.">

			</option>

			<option value="Constrains ST so that no translations are allowed.">

			</option>

			<option value="Abstract ancestor for captions."></option>

			<option value="Applies style to cells in a group of columns.">

			</option>

			<option value="Describes content model components."></option>

			<option value="Describes content model components."></option>

			<option value="Describes content model components."></option>

			<option value="Describes content model components."></option>

			<option value="Describes content model components."></option>

			<option value="Wrapper for a string of text."></option>

			<option value="Reference to a footnote."></option>

			<option value="Indicates a footnote."></option>

			<option value="Item in a list."></option>

			<option value="Specified alignment characeter on each line.">

			</option>

			<option value="Hypertext reference to another document."></option>

			<option value="Similar to an HTML list."></option>

			<option
				value="Allows narrative to be broken up into consistent structures.">

			</option>

			<option value="References multimedia content in a document.">

			</option>

			<option value="Subscript text value."></option>

			<option value="Abstract container for table items."></option>

			<option value="A table."></option>

			<option value="A cell in a table."></option>

			<option value="Cell in a table."></option>

			<option value="Restricts footnote to title information."></option>

			<option value="Group of rows."></option>

			<option value="Describes a type of row."></option>

			<option value="Row in a table."></option>

			<option value="Basic style and attributes for a document.">

			</option>

			<option value="A hard line break."></option>

			<option
				value="Label for paragraph, list, list item, table, or table cell.">

			</option>

			<option value="Abstract ancestor for properties of col and colgroup.">

			</option>

			<option value="Applies style to cells in a column."></option>

			<option value="Superscript text value."></option>

			<option value="Definition of structured text."></option>

			<option value="Definition of a structured title."></option>

			<option value="Constrains ST.NT to no language"></option>

			<option value="Character string datatype stands for text data.">

			</option>

			<option
				value="Constrains the TEL.PERSON type to be an email address.">

			</option>

			<option
				value="Constrains TEL to a method of communication with a person.">

			</option>

			<option
				value="Constrains TEL to telephone commmunication with a person.">

			</option>

			<option
				value="Constrains TEL points to resource with binary content.">

			</option>

			<option value="Locatable resource identified with a URI."></option>

			<option value="Constrains TS so that it must refer to a birth date.">

			</option>

			<option
				value="Constrains TS so that it may only conatin a date value.">

			</option>

			<option value="Constrains TS.DATE to reference to a particular day.">

			</option>

			<option
				value="Constrains TS.DATETIME to a particular timezone second.">

			</option>

			<option value="Constrains TS to not be more precise than seconds.">

			</option>

			<option
				value="Quantity specifying a point on the axis of natural time.">

			</option>

			<option value="Typed parameter."></option>

			<option
				value="Constrains URG to high provided and highClosed is true.">

			</option>

			<option
				value="Constrains URG to low required and the lowClosed true.">

			</option>

			<option value="Values from a range of possible values of the type T.">

			</option>

			<option value="Uncertain Value-Probabilistic"></option>

			<option value="A local java datatype - TreeNode."></option>

			<option value="Java Primitive - byte-length integer."></option>

			<option value="Java Primitive - single characterShort integer.">

			</option>

			<option
				value="Java Primitive - double-precision floating point number.">

			</option>

			<option
				value="Java Primitive - single-precision floating point number.">

			</option>

			<option value="Java Primitive - Integer."></option>

			<option value="Java datatype - array of integers."></option>

			<option value="Java Primitive - long integer."></option>

			<option value="Java datatype - root of class hierarchy."></option>

			<option value="Java Primitive - short integer."></option>

			<option
				value="Java datatype - class that represents character strings.">

			</option>

			<option value="Java datatype - array of strings."></option>

			<option value="Java datatype -array of strings arrays."></option>

			<option value="Java - reference placeholder for the Java word void.">

			</option>

			<option
				value="Java datatype - arbitrary-precision signed decimal numbers.">

			</option>

			<option value="Java SQL datatype - binary large object."></option>

			<option value="Java SQL datatype - character large object.">

			</option>

			<option
				value="Java SQL datatype - thin wrapper around java.util.Date">

			</option>

			<option
				value="Java datatype - represents resizable-array, List interface">

			</option>

			<option value="Java datatype - represents a group of objects.">

			</option>

			<option
				value="Java datatype - represents a specific instant in time. ">

			</option>

			<option value="Java datatype - implements the set interface.">

			</option>

			<option
				value="Java datatype - implements hashtable mapping keys to values.">

			</option>

			<option
				value="Java datatype - maps keys to single, non-duplicate values.">

			</option>

			<option
				value="Java datatype - collection containing no duplicate elements.">

			</option>

			<option
				value="Java datatype - implements a growable array of objects. ">

			</option>

			<option value="Java datatype - general purpose node in a data tree">

			</option>

			<option value="A number that may be used in calculations"></option>

			<option
				value="Oracle Clinical dtatype-contains alphanumeric and numeric">
				The Oracle "Numeric Alpha DVG" datatype signifies that data fields
				with the type NUMERIC can contain alphanumeric data in addition to
				the type of data defined by the original datatype. The assignment of
				this datatype permits validation of specified alphanumeric data
				codes and allows them to be entered without alerting the data entry
				operator or necessarily creating a discrepancy. For example, a field
				used for recording a Lab Value Number would accept the text
				"Unknown" in addition to a numeric value without causing an error.
				Examples at
				http://www.csscomp.com/web/training/docs/Global_Library_4_Practice.pdf
			</option>

			<option value="representation is an object"></option>

			<option value="An array of Strings"></option>

			<option
				value="Scable Vector Graphic - XML file format for 2-D graphics 
">

			</option>

			<option value="A complex datatype composed of data elements">

			</option>

			<option
				value="A time of day specifying hours, minutes, and (opt.) seconds">

			</option>

			<option value="Represents a sequence of octets."></option>

			<option value="Enumeration whose values are true and false.">

			</option>

			<option
				value="Simple string that has a restricted set of possible values.">

			</option>

			<option value="Number that can be values from 0-255; Byte">

			</option>

			<option
				value="String that is an identifier of OID, UUID, or simple token.">

			</option>

			<option value="Simple internet URL or URI."></option>

			<option value="Placeholder for any XML content."></option>

			<option
				value="Represents a Uniform Resource Identifier Reference (URI).">

			</option>

			<option value="Base64-encoded binary data."></option>

			<option value="Binary-valued logic."></option>

			<option value="8-bit intergers form -128 to +127"></option>

			<option value="Object with year, month and day."></option>

			<option
				value="Integer year, month, day, hour, minute, second, timezone.">

			</option>

			<option
				value="Subset of real numbers represented by decimal numbers.">

			</option>

			<option value="Double precision 64-bit floating point numbers.">

			</option>

			<option value="Single-precision 32-bit floating point numbers.">

			</option>

			<option value="Represents the ID attribute type."></option>

			<option value="Represents the IDREF attribute type."></option>

			<option value="32-bit integers"></option>

			<option
				value="Value of fractionDigits to be 0 with no decimal point.">

			</option>

			<option value="64-bit integers"></option>

			<option value="16-bit integers"></option>

			<option value="Character strings in XML."></option>

			<option value="An instance of time occuring daily."></option>

		</select>
		<!-- store datatype scheme-ref and annotation to use later -->
		<select name="datatypeSRef" size="1"
			style="visibility:hidden;width:100;" multiple>

			<option value=""></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Registry Defined"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="HL7 Scheme Reference"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="Not Specified"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="ISO 21090"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

			<option value="WC3 XML Schema"></option>

		</select>

		<!-- stores the selected rows to get the bean from the search results -->
		<select name="hiddenSelRow" size="1"
			style="visibility:hidden;width:100" multiple></select>
</sj:div>

