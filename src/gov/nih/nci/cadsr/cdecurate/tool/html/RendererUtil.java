package gov.nih.nci.cadsr.cdecurate.tool.html;

public class RendererUtil {

	/**
	 * Method to output select option.
	 * 
	 * @param elementOption	the current html option (generally in a loop)
	 * @param userSelectedOption the saved user selection (say in a session)
	 * @return the final html snippet
	 */
	public static String toSelectOption(String elementOption, String userSelectedOption) {
		String template = "<option value=\"" + elementOption + "\" ";
		
		if(elementOption.equals(userSelectedOption)) {
			template += "selected=\"selected\"";
		}

		template += ">" + elementOption;
		template += "</option>";
		
		return template;
	}

}
