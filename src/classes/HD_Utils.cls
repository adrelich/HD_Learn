/**
 * Created by Britenet on 03.12.2017.
 */

public with sharing class HD_Utils {
    private static User currentUser;

    public static User getLoginUser(String userID) {
        List<User> loginUsers = [SELECT Id, Name, Country FROM User WHERE Id = :userID];
        if (loginUsers.size() > 0) {
            return loginUsers[0];
        }
        return null;
    }

    public static User getCurrentUser() {
        if (currentUser == null || (currentUser != null && currentUser.Id != UserInfo.getUserId())) {
            currentUser = getLoginUser(UserInfo.getUserId());
        }
        return currentUser;
    }

    public static String[] getAddressEmailPublicGroup(String groupName) {

        String[] listsAddress = new String[]{
        };
        List<User> groupList = [SELECT Name, Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE Group.Name = :groupName)];
        if (!groupList.isEmpty()) {
            for (User userItem : groupList) {
                listsAddress.add(userItem.Email);
            }
        }
        return listsAddress;
    }


    public static Id uploadAttachment(Blob uploadFile, String filename, Id parentId) {
        Attachment att = new Attachment();
        att.Body = uploadFile;
        att.Name = fileName;
        att.ParentId = parentId;
        insert att;
        return att.Id;
    }

    public static void reloadAttachment(Blob uploadFile, Id attId) {
        List<Attachment> attList = [SELECT Id, Body FROM Attachment WHERE Id = :attId LIMIT 1];
        if (!attList.isEmpty()) {
            Attachment attItem = attList[0];
            attItem.Body = uploadFile;
            upsert attItem;
        }
    }

    public static Id getChatterGroupId(String chatterGroupName) {
        HD_Chatter_Group__c chatterGroup = HD_Chatter_Group__c.getInstance(chatterGroupName);
        if (chatterGroup != null) {
            try {
                Id groupId = Id.valueOf(chatterGroup.Group_Id__c);
                return groupId;
            } catch (Exception ex) {
                System.debug('HD_Utils.getChatterGroupId - Exception : ' + ex.getMessage());
            }
        }
        return null;
    }
}