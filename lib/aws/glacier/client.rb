# Copyright 2011-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module AWS
  class Glacier

    # All operations with Amazon Glacier require your AWS account ID.
    # You can get your AWS account ID by:
    #
    # * Go to http://aws.amazon.com and log in with your AWS account
    # * Click on "My Account/Console" > "Security Credentials"
    # * Scroll to the bottom of the page to "Account Identifiers"
    # * Copy the AWS Account ID string (e.g. 1234-5678-9012)
    #
    # If you configure your account ID with AWS.config, then you do not
    # need to provide it for each service request.
    #
    #   AWS.config(
    #     :access_key_id => '...',
    #     :secret_access_key => '...',
    #     :account_id => '1234-5678-9012')
    #
    #   glacier = Glacier.new
    #
    #   resp = glacier.client.list_vaults() # no need ot pass :account_id here
    #
    #   resp[:vault_list].each {|vault| ... }
    #
    class Client < Core::RESTJSONClient

      define_client_methods('2012-06-01')

      # @private
      CACHEABLE_REQUESTS = Set[]

      ## client methods ##

      # @!method abort_multipart_upload(options = {})
      # Calls the DELETE AbortMultipartUpload API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:upload_id+ - *required* - (String)
      # @return [Core::Response]

      # @!method complete_multipart_upload(options = {})
      # Calls the POST CompleteMultipartUpload API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:upload_id+ - *required* - (String)
      # * +:archive_size+ - (String)
      # * +:checksum+ - *required* - (String)
      # * +:content_sha256+ - (String)
      # @return [Core::Response]

      # @!method create_vault(options = {})
      # Calls the PUT CreateVault API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # @return [Core::Response]

      # @!method delete_archive(options = {})
      # Calls the DELETE DeleteArchive API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:archive_id+ - *required* - (String)
      # @return [Core::Response]

      # @!method delete_vault(options = {})
      # Calls the DELETE DeleteVault API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # @return [Core::Response]

      # @!method delete_vault_notifications(options = {})
      # Calls the DELETE DeleteVaultNotifications API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # @return [Core::Response]

      # @!method describe_job(options = {})
      # Calls the GET DescribeJob API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:job_id+ - *required* - (String)
      # @return [Core::Response]
      #   The #data method of the response object returns
      #   a hash with the following structure:
      #   * +JobId+ - (String)
      #   * +JobDescription+ - (String)
      #   * +Action+ - (String)
      #   * +ArchiveId+ - (String)
      #   * +VaultARN+ - (String)
      #   * +CreationDate+ - (String)
      #   * +Completed+ - (Boolean)
      #   * +StatusCode+ - (String)
      #   * +StatusMessage+ - (String)
      #   * +ArchiveSizeInBytes+ - (Integer)
      #   * +InventorySizeInBytes+ - (Integer)
      #   * +SNSTopic+ - (String)
      #   * +CompletionDate+ - (String)
      #   * +SHA256TreeHash+ - (String)

      # @!method describe_vault(options = {})
      # Calls the GET DescribeVault API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # @return [Core::Response]
      #   The #data method of the response object returns
      #   a hash with the following structure:
      #   * +VaultARN+ - (String)
      #   * +VaultName+ - (String)
      #   * +CreationDate+ - (String)
      #   * +LastInventoryDate+ - (String)
      #   * +NumberOfArchives+ - (Integer)
      #   * +SizeInBytes+ - (Integer)

      # @!method get_job_output(options = {})
      # Calls the GET GetJobOutput API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:job_id+ - *required* - (String)
      # * +:range+ - (String)
      # @return [Core::Response]

      # @!method get_vault_notifications(options = {})
      # Calls the GET GetVaultNotifications API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # @return [Core::Response]
      #   The #data method of the response object returns
      #   a hash with the following structure:
      #   * +vaultNotificationConfig+ - (Hash)
      #     * +SNSTopic+ - (String)
      #     * +Events+ - (Array<String>)

      # @!method initiate_job(options = {})
      # Calls the POST InitiateJob API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:job_parameters+ - (Hash)
      #   * +:format+ - (String)
      #   * +:type+ - (String)
      #   * +:archive_id+ - (String)
      #   * +:description+ - (String)
      #   * +:sns_topic+ - (String)
      # @return [Core::Response]

      # @!method initiate_multipart_upload(options = {})
      # Calls the POST InitiateMultipartUpload API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:archive_description+ - (String)
      # * +:part_size+ - (String)
      # @return [Core::Response]

      # @!method list_jobs(options = {})
      # Calls the GET ListJobs API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:limit+ - (String)
      # * +:marker+ - (String)
      # * +:statuscode+ - (String)
      # * +:completed+ - (String)
      # @return [Core::Response]
      #   The #data method of the response object returns
      #   a hash with the following structure:
      #   * +JobList+ - (Array<Hash>)
      #     * +JobId+ - (String)
      #     * +JobDescription+ - (String)
      #     * +Action+ - (String)
      #     * +ArchiveId+ - (String)
      #     * +VaultARN+ - (String)
      #     * +CreationDate+ - (String)
      #     * +Completed+ - (Boolean)
      #     * +StatusCode+ - (String)
      #     * +StatusMessage+ - (String)
      #     * +ArchiveSizeInBytes+ - (Integer)
      #     * +InventorySizeInBytes+ - (Integer)
      #     * +SNSTopic+ - (String)
      #     * +CompletionDate+ - (String)
      #     * +SHA256TreeHash+ - (String)
      #   * +Marker+ - (String)

      # @!method list_multipart_uploads(options = {})
      # Calls the GET ListMultipartUploads API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:upload_id_marker+ - (String)
      # * +:limit+ - (String)
      # @return [Core::Response]
      #   The #data method of the response object returns
      #   a hash with the following structure:
      #   * +UploadsList+ - (Array<Hash>)
      #     * +MultipartUploadId+ - (String)
      #     * +VaultARN+ - (String)
      #     * +ArchiveDescription+ - (String)
      #     * +PartSizeInBytes+ - (Integer)
      #     * +CreationDate+ - (String)
      #   * +Marker+ - (String)

      # @!method list_parts(options = {})
      # Calls the GET ListParts API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:upload_id+ - *required* - (String)
      # * +:marker+ - (String)
      # * +:limit+ - (String)
      # @return [Core::Response]
      #   The #data method of the response object returns
      #   a hash with the following structure:
      #   * +MultipartUploadId+ - (String)
      #   * +VaultARN+ - (String)
      #   * +ArchiveDescription+ - (String)
      #   * +PartSizeInBytes+ - (Integer)
      #   * +CreationDate+ - (String)
      #   * +Parts+ - (Array<Hash>)
      #     * +RangeInBytes+ - (String)
      #     * +SHA256TreeHash+ - (String)
      #   * +Marker+ - (String)

      # @!method list_vaults(options = {})
      # Calls the GET ListVaults API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:marker+ - (String)
      # * +:limit+ - (String)
      # @return [Core::Response]
      #   The #data method of the response object returns
      #   a hash with the following structure:
      #   * +VaultList+ - (Array<Hash>)
      #     * +VaultARN+ - (String)
      #     * +VaultName+ - (String)
      #     * +CreationDate+ - (String)
      #     * +LastInventoryDate+ - (String)
      #     * +NumberOfArchives+ - (Integer)
      #     * +SizeInBytes+ - (Integer)
      #   * +Marker+ - (String)

      # @!method set_vault_notifications(options = {})
      # Calls the PUT SetVaultNotifications API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:vault_notification_config+ - (Hash)
      #   * +:sns_topic+ - (String)
      #   * +:events+ - (Array<String>)
      # @return [Core::Response]

      # @!method upload_archive(options = {})
      # Calls the POST UploadArchive API operation.
      # @param [Hash] options
      # * +:vault_name+ - *required* - (String)
      # * +:account_id+ - *required* - (String)
      # * +:archive_description+ - (String)
      # * +:checksum+ - *required* - (String)
      # * +:body+ - (File,Pathname,IO,String)
      # * +:content_sha256+ - (String)
      # @return [Core::Response]

      # @!method upload_multipart_part(options = {})
      # Calls the PUT UploadMultipartPart API operation.
      # @param [Hash] options
      # * +:account_id+ - *required* - (String)
      # * +:vault_name+ - *required* - (String)
      # * +:upload_id+ - *required* - (String)
      # * +:checksum+ - *required* - (String)
      # * +:range+ - (String)
      # * +:body+ - (File,Pathname,IO,String)
      # * +:content_sha256+ - (String)
      # @return [Core::Response]

      ## end client methods ##

    end
  end
end
