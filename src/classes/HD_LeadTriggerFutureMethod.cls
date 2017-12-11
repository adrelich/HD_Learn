/**
 * Created by Britenet on 04.12.2017.
 */

global without sharing class HD_LeadTriggerFutureMethod {
    @future
    public static void createFeetChatter(Id leadIds) {
        List<FeedItem> listFeed = new List<FeedItem>();
        for (Lead leadItem : [SELECT Id, FirstName, LastName FROM Lead WHERE Id = :leadIds]) {
            FeedItem post = new FeedItem(Body = 'Create new Lead:' + leadItem.FirstName + ' ' + leadItem.LastName, ParentId = leadItem.Id, Type = 'TextPost');
            listFeed.add(post);
        }
        if(!listFeed.isEmpty()) {
            insert listFeed;
        }
    }
}