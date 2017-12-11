public class HD_Lead_InsertAction {
    @InvocableMethod
    public static void CreatePostOnChatter(List<Id> leads) {
        List<FeedItem> feedItemList = new List<FeedItem>();
        Id groupId = HD_Utils.getChatterGroupId('SalesRepGroup');
        if(groupId != null) {
            for (Lead idLead : [SELECT Id, FirstName, LastName FROM Lead WHERE Id = :leads]) {

                FeedItem post = new FeedItem();
                post.ParentId = groupId;
                post.Type = 'LinkPost';
                post.Title = Label.Go_to_the_Lead;
                post.Body = String.format(Label.Create_new_Lead, new String[]{
                        idLead.FirstName, idLead.LastName
                });
                post.LinkURL = System.URL.getSalesforceBaseUrl().toExternalForm().replace('salesforce','lightning.force') + '/' + idLead.Id;
                feedItemList.add(post);
            }
            if (!feedItemList.isEmpty()) {
                try {
                    insert feedItemList;
                } catch (Exception ex) {
                    System.debug('HD_Lead_InsertAction.CreatePostOnChatter - Exception : ' + ex.getMessage());
                }
            }
        }
    } 
}