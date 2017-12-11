/**
 * Created by Britenet on 07.12.2017.
 */

public with sharing class HD_Lead_UpdateStatusToMeetingController {

    private final Lead leadRecord;

    public HD_Lead_UpdateStatusToMeetingController(ApexPages.StandardController stdController) {
        this.leadRecord = (Lead)stdController.getRecord();
    }

    public void updateRecord() {
        this.leadRecord.Status = 'Meeting';
        update this.leadRecord;
    }
}