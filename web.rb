# see https://github.com/mu-semtech/mu-ruby-template for more info
get '/' do
  content_type 'application/json'
  job_uuid = generate_uuid()
  update <<QUERY
    INSERT DATA {
      GRAPH <http://mu.semte.ch/application> {
        <http://mu.semte.ch/vocabularies/ext/mock-jobrunner/resources/#{job_uuid}>
          a <http://mu.semte.ch/vocabularies/ext/jobrunner/Job>;
          <http://mu.semte.ch/vocabularies/mu/uuid> #{job_uuid.sparql_escape};
          <http://mu.semte.ch/vocubalaries/ext/jobrunner/status>
            <http://mu.semte.ch/vocubalaries/ext/jobrunner/Running>.
      }
    }
QUERY
  sleep 5
  update <<QUERY
    DELETE {
      GRAPH <http://mu.semte.ch/application> {
        <http://mu.semte.ch/vocabularies/ext/mock-jobrunner/resources/#{job_uuid}>
          <http://mu.semte.ch/vocubalaries/ext/jobrunner/status>
            <http://mu.semte.ch/vocubalaries/ext/jobrunner/Running>.
      }
    }
    INSERT {
      GRAPH <http://mu.semte.ch/application> {
        <http://mu.semte.ch/vocabularies/ext/mock-jobrunner/resources/#{job_uuid}>
          <http://mu.semte.ch/vocubalaries/ext/jobrunner/status>
            <http://mu.semte.ch/vocubalaries/ext/jobrunner/Completed>.
      }
    }
QUERY

  { data: { attributes: {
              id: job_uuid,
              type: 'jobs'
            } } }.to_json
end
