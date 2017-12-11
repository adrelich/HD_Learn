/**
 * Created by Britenet on 07.12.2017.
 */

global class HD_Surveys_InsertAction {

    private class AnswerWrapper {
        public String LeadName { get; set; }
        public Id LeadId { get; set; }
        public List<String> answer { get; set; }

        public AnswerWrapper(String LeadName, Id LeadId) {
            this.LeadName = LeadName;
            this.LeadId = LeadId;
            this.answer = new List<String>();
        }
    }

    @Future
    public static void CreateAnswerSurweyOnChatter(Id surveyTakerId) {
        AnswerWrapper aw = createMapFromAnswer(surveyTakerId);
        Id groupId = HD_Utils.getChatterGroupId('SalesRepGroup');
        if (aw != null && groupId != null) {
            FeedItem post = new FeedItem();
            post.ParentId = groupId;
            post.Type = 'LinkPost';
            post.Title = Label.Go_to_the_Lead;
            post.Body = createFeedItemBody(aw);
            System.debug('LINK: ' + System.URL.getSalesforceBaseUrl().toExternalForm());
            System.debug('LINK: ' + System.URL.getSalesforceBaseUrl().toExternalForm().replace('salesforce','lightning.force'));
            post.LinkURL = System.URL.getSalesforceBaseUrl().toExternalForm().replace('salesforce','lightning.force') + '/' + aw.LeadId;
            insert post;
        }
    }

    private static String createFeedItemBody(AnswerWrapper aw) {
        String body = String.format(Label.Answer_from_survey, new String[]{
                aw.LeadName
        });
        for (Integer i = 1; i <= aw.answer.size(); i++) {
            body += String.format('\r\n {0}.{1}', new String[]{
                    String.valueOf(i), aw.answer[i - 1]
            });
        }
        return body;
    }

    private static AnswerWrapper createMapFromAnswer(Id surveyTakerId) {
        AnswerWrapper aw = null;
        List<SurveyQuestionResponse__c> answer = [SELECT Survey_Question__r.Name, Response__c, SurveyTaker__r.Lead__r.FirstName, SurveyTaker__r.Lead__r.LastName, SurveyTaker__r.Lead__c from SurveyQuestionResponse__c WHERE SurveyTaker__r.Id = :surveyTakerId];
        if (!answer.isEmpty()) {
            aw = new AnswerWrapper(String.format('{0} {1}', new String[]{
                    answer[0].SurveyTaker__r.Lead__r.FirstName, answer[0].SurveyTaker__r.Lead__r.LastName
            }), answer[0].SurveyTaker__r.Lead__c);
            for (SurveyQuestionResponse__c item : answer) {
                aw.answer.add(String.format('{0} : {1}', new String[]{
                        item.Survey_Question__r.Name, item.Response__c
                }));
            }
        }
        return aw;
    }
}