<ArcPad>
	<LAYER name="Polygons">
		<FORMS>
			<EDITFORM name="EDITFORM" caption="Polygons" width="130" height="80" attributespagevisible="false">
				<PAGE name="PAGE1" caption="Polygon">
					<LABEL name="LABEL1" caption="Name" x="1" y="1" width="43" height="12" tooltip=""/>
					<EDIT name="NAME" field="NAME" x="45" y="1" width="84" height="12" border="true" tabstop="true" tooltip="" defaultvalue=""/>
					<LABEL name="LABEL2" caption="Category" x="1" y="14" width="43" height="12" tooltip=""/>
					<SYMBOLOGYFIELD name="CATEGORY" field="CATEGORY" x="45" y="14" width="84" height="12" border="true" tabstop="true" tooltip="" limittolist="false" defaultvalue="1"/>
					<LABEL name="LABEL3" caption="Date" x="1" y="27" width="43" height="14" tooltip=""/>
					<DATETIME name="DATE" field="DATE" x="45" y="27" width="84" height="14" border="true" tabstop="true" allownulls="false" tooltip=""/>
					<LABEL name="LABEL4" caption="Comments" x="1" y="42" width="43" height="12" tooltip=""/>
					<EDIT name="COMMENTS" field="COMMENTS" x="45" y="42" width="84" height="36" border="true" tabstop="true" tooltip="" multiline="true" defaultvalue=""/>
				</PAGE>
			</EDITFORM>
		</FORMS>
		<HYPERLINK field="PHOTO" path=""/>
		<SYMBOLOGY>
			<SIMPLELABELRENDERER field="NAME" visible="true" rotationfield="" expression="" language="">
				<TEXTSYMBOL fontcolor="Black" font="Tahoma" fontstyle="regular" fontsize="9"/>
			</SIMPLELABELRENDERER>
			<VALUEMAPRENDERER lookupfield="Category">
				<EXACT value="1" label="Category 1">
					<SIMPLEPOLYGONSYMBOL filltype="solid" fillcolor="Beige" backgroundcolor="Black" boundarywidth="1"/>
				</EXACT>
				<EXACT value="2" label="Category 2">
					<SIMPLEPOLYGONSYMBOL filltype="solid" fillcolor="LightskyBlue" backgroundcolor="Black" boundarywidth="1"/>
				</EXACT>
				<EXACT value="3" label="Category 3">
					<SIMPLEPOLYGONSYMBOL filltype="solid" fillcolor="Gold" backgroundcolor="Black" boundarywidth="1"/>
				</EXACT>
				<EXACT value="4" label="Category 4">
					<SIMPLEPOLYGONSYMBOL filltype="solid" fillcolor="LightGreen" backgroundcolor="Black" boundarywidth="1"/>
				</EXACT>
				<EXACT value="5" label="Category 5">
					<SIMPLEPOLYGONSYMBOL filltype="solid" fillcolor="Plum" backgroundcolor="Black" boundarywidth="1"/>
				</EXACT>
				<OTHER label="&lt;Other&gt;">
					<SIMPLEPOLYGONSYMBOL filltype="solid" fillcolor="BlanchedAlmond" backgroundcolor="Black" boundarywidth="1"/>
				</OTHER>
			</VALUEMAPRENDERER>
		</SYMBOLOGY>
		<QUERY where=""/>
	</LAYER>
</ArcPad>
