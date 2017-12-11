/**
 * Created by Britenet on 04.12.2017.
 */

global class HD_PublicSiteController {

    public HD_PublicSiteController(ApexPages.StandardController standardController) {}
    public HD_PublicSiteController() {
    }

    @RemoteAction
    global static String saveLead(Lead jsonLead) {
        if(jsonLead != null) {
            try {
                insert jsonLead;
                //HD_LeadTriggerFutureMethod.createFeetChatter(jsonLead.Id)
            } catch (Exception ex) {
                return ex.getMessage();
            }
        }
        return string.valueOf(jsonLead.Id);
    }
}